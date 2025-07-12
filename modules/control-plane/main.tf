terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }
  }
}

# Create master nodes
resource "hcloud_server" "master_node" {
  count       = var.master_count
  name        = "${var.label_vms["cluster_name"]}-master-${count.index + 1}"
  image       = var.master_image
  server_type = var.master_server_type
  location    = var.master_location[count.index]
  ssh_keys    = [var.ssh_key_id]
  
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  network {
    network_id = var.network_id
    ip         = cidrhost(var.network_cidr, 101 + count.index)
  }

  labels = {
      cluster = var.label_vms["cluster_name"]
      role = var.label_vms["controlplane"]
  }
}
