output "key_id" {
  description = "ID of the key"
  value       = hcloud_ssh_key.htz-key.id
}

output "ssh_key_out" {
    description = "Key Name"
    value = "SSH Key Name: ${hcloud_ssh_key.htz-key.name}"
}