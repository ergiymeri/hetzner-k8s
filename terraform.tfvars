# Hetzner Cloud configuration
hcloud_token = "your-api-token"

# Cluster configuration
cluster_name     = "hcloud-k8s-cluster"
ssh_key_name     = "hetzner-k8s"
private_key_path = "./keys/hetzner-k8s"

# Network configuration
vpc_name     = "k8s-cluster-vpc"
vpc_cidr     = "172.16.0.0/16"
subnet_cidr  = "172.16.0.0/24"
subnet_type  = "cloud"
network_zone = "eu-central"

# Master node configuration
master_count       = 3
master_server_type = "cpx11"
master_location    = ["nbg1", "fsn1", "hel1"]
master_image       = "ubuntu-24.04"

# Worker node configuration
worker_count       = 3
worker_server_type = "cpx11"
worker_location    = ["nbg1", "fsn1", "hel1"]
worker_image       = "ubuntu-24.04"

# VPN node configuration
vpn_hostname    = "wg-vpn"
vpn_server_type = "cpx11"
vpn_location    = "fsn1"
vpn_image       = "ubuntu-24.04"
vpn_private_ip  = "172.16.0.20"

# Load Balancer configuration
lb_name       = "controlplane-lb"
lb_type       = "lb11"
lb_location   = "nbg1"
lb_private_ip = "172.16.0.10"

# Labels Name
label_vms = {
  cluster      = "cluster"
  cluster_name = "hcloud-k8s-cluster"
  controlplane = "controlplane"
  worker       = "worker"
  vpn          = "vpn"
  role         = "role"
}

# Firewall
ssh_port = "22"