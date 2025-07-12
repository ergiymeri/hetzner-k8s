output "vpc_name" {
  value = "Name of VPC: ${module.vpc.vpc_name}"
}

output "vpc_cidr" {
  value = "VPC CIDR: ${var.vpc_cidr}"
}

output "subnet_id" {
  value = "ID of Subnet: ${module.subnet.subnet_id}"
}

output "subnet_cidr" {
  value = "Subnet CIDR: ${var.subnet_cidr}"
}

output "network_zone" {
  value = "Network Zone: ${var.network_zone}"
}

output "lb_name" {
  value = "Load Balancer for K8S HA: ${module.load-balancer.lb_name}"
}

output "master_ips" {
  value = [
    for i, ip in module.control-plane.master_ips :
    "Control Plane ${i + 1}: ${ip}"
  ]
}

output "worker_ips" {
  value = [
    for i, ip in module.worker-nodes.worker_ips :
    "Worker Nodes ${i + 1}: ${ip}"
  ]
}


output "firewall_rules" {
  description = "Firewall resource with all details"
  value       = module.firewall.firewall_rules
}
