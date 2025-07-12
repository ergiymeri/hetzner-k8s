variable "network_id" {
  description = "ID of the network"
  type        = string
}

variable "network_cidr" {
  description = "CIDR block of the network"
  type        = string
}

variable "label_vms" {
  type = map(string)
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

# Master node variables
variable "master_count" {
  description = "Number of master nodes"
  type        = number
}

variable "master_server_type" {
  description = "Server type for master nodes"
  type        = string
}

variable "master_location" {
  description = "Location for master nodes"
  type        = list(string)
}

variable "master_image" {
  description = "Image for master nodes"
  type        = string
}

