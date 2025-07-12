terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

# Network module
module "vpc" {
  source = "./modules/vpc"

  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
}

# Subnet module
module "subnet" {
  source = "./modules/subnet"

  network_id   = module.vpc.vpc_id
  subnet_type  = var.subnet_type
  network_zone = var.network_zone
  subnet_cidr  = var.subnet_cidr

  depends_on = [module.vpc]
}

# SSH module
module "ssh-key" {
  source = "./modules/ssh-key"

  ssh_key_name = var.ssh_key_name
}



# Control Plane module
module "control-plane" {
  source = "./modules/control-plane"

  # Network configuration
  network_id   = module.vpc.vpc_id
  network_cidr = var.vpc_cidr

  # Keys Config
  ssh_key_id       = module.ssh-key.key_id
  ssh_key_name     = var.ssh_key_name
  private_key_path = var.private_key_path

  # Master node configuration
  master_count       = var.master_count
  master_server_type = var.master_server_type
  master_location    = var.master_location
  master_image       = var.master_image

  label_vms = var.label_vms

  depends_on = [module.ssh-key]
}

# Load Balancer module
module "load-balancer" {
  source = "./modules/loadbalancer"

  lb_name     = var.lb_name
  lb_location = var.lb_location
  lb_type     = var.lb_type

  # Network configuration
  lb_private_ip = var.lb_private_ip
  network_id    = module.vpc.vpc_id
  label_vms     = var.label_vms

  depends_on = [module.control-plane]
}

# Worker Nodes Module
module "worker-nodes" {
  source = "./modules/worker-nodes"

  # Network configuration
  network_id   = module.vpc.vpc_id
  network_cidr = var.vpc_cidr

  # Keys Config
  ssh_key_id       = module.ssh-key.key_id
  ssh_key_name     = var.ssh_key_name
  private_key_path = var.private_key_path

  # Worker node configuration
  worker_count       = var.worker_count
  worker_server_type = var.worker_server_type
  worker_location    = var.worker_location
  worker_image       = var.worker_image
  label_vms          = var.label_vms

  depends_on = [
    module.control-plane
  ]
}

# Vpn Node Module
module "vpn-node" {
  source = "./modules/vpn"

  # Network configuration
  network_id     = module.vpc.vpc_id
  vpn_private_ip = var.vpn_private_ip

  # Keys Config
  ssh_key_id       = module.ssh-key.key_id
  ssh_key_name     = var.ssh_key_name
  private_key_path = var.private_key_path

  # VPN node configuration
  vpn_hostname    = var.vpn_hostname
  vpn_server_type = var.vpn_server_type
  vpn_location    = var.vpn_location
  vpn_image       = var.vpn_image
  label_vms       = var.label_vms

  depends_on = [
    module.worker-nodes
  ]
}

# Get All ip entries and format it
locals {
  control_ips = module.control-plane.master_ips
  control_ids = module.control-plane.master_id
  worker_ips  = module.worker-nodes.worker_ips
  worker_ids  = module.worker-nodes.worker_id

  # Format control-plane entries
  control_yaml = join(
    "\n",
    [
      for idx, ip in local.control_ips :
      idx == 0
      ? "        ${ip}:\n          init_k8s_cluster: true"
      : "        ${ip}:"
    ]
  )

  # Format worker entries
  worker_yaml = join(
    "\n",
    [
      for ip in local.worker_ips :
      "        ${ip}:"
    ]
  )


  control_nodes = [
    for idx in range(length(local.control_ips)) : {
      name        = "${var.label_vms["cluster_name"]}-master-${idx + 1}"
      ip          = local.control_ips[idx]
      provider_id = local.control_ids[idx]
    }
  ]

  worker_nodes = [
    for idx in range(length(local.worker_ips)) : {
      name        = "${var.label_vms["cluster_name"]}-worker-${idx + 1}"
      ip          = local.worker_ips[idx]
      provider_id = local.worker_ids[idx]
    }
  ]


  cp_nodes_yaml = join("\n", [
    for node in local.control_nodes :
    "  - name: ${node.name}\n    ip: ${node.ip}\n    provider_id: ${node.provider_id}"
  ])

  worker_nodes_yaml = join("\n", [
    for node in local.worker_nodes :
    "  - name: ${node.name}\n    ip: ${node.ip}\n    provider_id: ${node.provider_id}"
  ])
}

# Create Inventory file for the ansible 
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory/inventory.yml"

  content = <<-EOT
    all:
      children:
        controlplane:
          hosts:
    ${local.control_yaml}
        worker:
          hosts:
    ${local.worker_yaml}
        vpn:
          hosts:
            ${module.vpn-node.vpn_public_ip}
  EOT
}

# Create variables file for hccm
resource "local_file" "k8s_nodes_yaml" {
  filename = "${path.module}/ansible/roles/hccm/vars/main.yml"

  content = <<-EOT
    controlplane_nodes:
  ${local.cp_nodes_yaml}
    worker_nodes:
  ${local.worker_nodes_yaml}
    hcloud_token: ${var.hcloud_token}
    network_id: ${module.vpc.vpc_id}
  EOT
}

# Install WireGuard
resource "null_resource" "install_wireguard" {
  depends_on = [local_file.ansible_inventory]

  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook ./ansible/playbooks/setup-wg.yml
    EOT
  }
}

# Deploy and install Kubernetes Cluster
resource "null_resource" "install_k8s" {
  depends_on = [local_file.ansible_inventory]

  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook ./ansible/playbooks/install-k8s.yml
    EOT
  }
}

# Install Hetzner Cloud Controller Manager and configure it
resource "null_resource" "install_hccm" {
  depends_on = [
    null_resource.install_k8s,
    local_file.k8s_nodes_yaml
  ]

  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook ./ansible/playbooks/install-hccm.yml
    EOT
  }
}

#Deploy Nginx Ingress Controller on Kubernetes Cluster
resource "null_resource" "install_nginx_ingress" {
  depends_on = [null_resource.install_hccm]

  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook ./ansible/playbooks/install-nginx-ingress.yml
    EOT
  }
}

# Wait until it is deployed
resource "null_resource" "wait_after_nginx_ingress" {
  depends_on = [null_resource.install_nginx_ingress]

  provisioner "local-exec" {
    command = "sleep 80"
  }
}


# Vpn Node Module
module "firewall" {
  depends_on = [null_resource.wait_after_nginx_ingress]

  source       = "./modules/firewall"
  cluster_name = var.cluster_name
  direction = {
    in  = "in"
    out = "out"
  }
  protocol = {
    tcp  = "tcp"
    icmp = "icmp"
  }
  ssh_port  = var.ssh_port
  source_ip = module.vpn-node.vpn_public_ip
  label_vms = var.label_vms
}
