terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }
  }
}

# Create VPN node
resource "hcloud_server" "vpn_node" {
  name        = "${var.vpn_hostname}"
  image       = var.vpn_image
  server_type = var.vpn_server_type
  location    = var.vpn_location
  ssh_keys    = [var.ssh_key_id]
  
  public_net {
    ipv4_enabled = true
    ipv6_enabled = false
  }

  network {
    network_id = var.network_id
    ip         = var.vpn_private_ip
  }

  labels = {
      role = var.label_vms["vpn"]
  }
}
