output "vpc_id" {
  description = "ID of the VPC"
  value       = hcloud_network.vpc.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = hcloud_network.vpc.name
}
