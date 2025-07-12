output "master_ips" {
  description = "Public IP addresses of master nodes"
  value       = hcloud_server.master_node[*].ipv4_address
}

output "master_id" {
  description = "HCLOUD ID of master nodes"
  value       = hcloud_server.master_node[*].id
}


output "master_private_ips" {
  description = "Private IP addresses of master nodes"
  value = [
    for server in hcloud_server.master_node :
    tolist(server.network)[0].ip
  ]
}