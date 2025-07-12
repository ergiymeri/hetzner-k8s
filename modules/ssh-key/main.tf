terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }
  }
}

# Create SSH Key
resource "hcloud_ssh_key" "htz-key" {
  name       = var.ssh_key_name
  public_key = file("${path.root}/keys/${var.ssh_key_name}.pub")
}