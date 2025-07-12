output "firewall_rules" {
  description = "Firewall resource with all details"
  value       = hcloud_firewall.k8s-cluster
}