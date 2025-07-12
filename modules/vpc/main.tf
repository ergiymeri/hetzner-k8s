terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }
  }
}

# Create VPC
resource "hcloud_network" "vpc" {
  name     = var.vpc_name
  ip_range = var.vpc_cidr
}