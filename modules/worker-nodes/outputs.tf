output "worker_ips" {
  description = "Public IP addresses of worker nodes"
  value       = hcloud_server.worker_node[*].ipv4_address
}

output "worker_id" {
  description = "HCLOUD ID of worker nodes"
  value       = hcloud_server.worker_node[*].id
}


output "worker_private_ips" {
  description = "Private IP addresses of worker nodes"
  value = [
    for server in hcloud_server.worker_node :
    tolist(server.network)[0].ip
  ]
}