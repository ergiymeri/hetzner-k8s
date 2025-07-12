terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.50"
    }
  }
}

resource "hcloud_load_balancer" "load_balancer" {
  name               = var.lb_name
  load_balancer_type = var.lb_type
  location           = var.lb_location
}

resource "hcloud_load_balancer_network" "lb_network" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  network_id = var.network_id
  ip               = var.lb_private_ip
  enable_public_interface = false
}


resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  label_selector   = "${var.label_vms["role"]}=${var.label_vms["controlplane"]}"
  use_private_ip   = true
  depends_on = [ hcloud_load_balancer_network.lb_network ]
}


resource "hcloud_load_balancer_service" "k8s-api" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "tcp"

  listen_port = 6443
  destination_port = 6443

  health_check {
    protocol = "tcp"
    port     = 6443
    interval = 10
    timeout  = 5
    retries = 3
  }

  depends_on = [ hcloud_load_balancer_target.load_balancer_target ]
}