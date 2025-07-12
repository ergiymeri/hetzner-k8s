variable "network_id" {
  description = "ID of the network"
  type        = string
}

variable "vpn_hostname" {
  description = "VPN Hostname"
  type        = string
}

variable "ssh_key_id" {
  description = "ID of the ssh key"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key in Hetzner Cloud"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private SSH key file"
  type        = string
}

variable "label_vms" {
  type = map(string)
}

variable "vpn_server_type" {
  description = "Server type for vpn nodes"
  type        = string
}

variable "vpn_location" {
  description = "Location for vpn nodes"
  type        = string
}

variable "vpn_image" {
  description = "Image for vpn nodes"
  type        = string
}

variable "vpn_private_ip" {
  description = "VPN private subnet ip"
  type        = string
}