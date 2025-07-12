terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }
  }
}


# Create worker nodes
resource "hcloud_server" "worker_node" {
  count       = var.worker_count
  name        = "${var.label_vms["cluster_name"]}-worker-${count.index + 1}"
  image       = var.worker_image
  server_type = var.worker_server_type
  location    = var.worker_location[count.index % length(var.worker_location)]
  ssh_keys    = [var.ssh_key_id]
  
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  network {
    network_id = var.network_id
    ip         = cidrhost(var.network_cidr, 201 + count.index)
  }

  labels = {
      cluster = var.label_vms["cluster_name"]
      role = var.label_vms["worker"]
  }
}
