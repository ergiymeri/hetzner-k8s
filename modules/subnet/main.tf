terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }
  }
}


resource "hcloud_network_subnet" "subnet" {
  network_id   = var.network_id
  type         = var.subnet_type
  network_zone = var.network_zone
  ip_range     = var.subnet_cidr
}