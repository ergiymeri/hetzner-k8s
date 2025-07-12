terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }
  }
}


resource "hcloud_firewall" "k8s-cluster" {
  name = var.cluster_name
  rule {
    direction = var.direction["in"]
    protocol  = var.protocol["icmp"]
    source_ips = [
      var.source_ip
    ]
  }

  rule {
    direction = var.direction["in"]
    protocol  = var.protocol["tcp"]
    port      = var.ssh_port
    source_ips = [
      var.source_ip
    ]
  }
}

resource "hcloud_firewall_attachment" "fw_ref" {
    firewall_id = hcloud_firewall.k8s-cluster.id
    label_selectors = [
      "${var.label_vms["cluster"]}=${var.label_vms["cluster_name"]}"
    ]
}