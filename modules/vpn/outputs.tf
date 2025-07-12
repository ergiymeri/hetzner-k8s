output "vpn_public_ip" {
  description = "Public IP addresse of vpn node"
  value       = hcloud_server.vpn_node.ipv4_address
}

output "vpn_id" {
  description = "HCLOUD ID of vpn node"
  value       = hcloud_server.vpn_node.id
}
