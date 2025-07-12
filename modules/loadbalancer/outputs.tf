output "lb_name" {
  description = "Name of Load Balancer"
  value       = hcloud_load_balancer.load_balancer.name
}

