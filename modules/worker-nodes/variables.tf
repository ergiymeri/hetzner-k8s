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

# Worker node variables
variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "worker_server_type" {
  description = "Server type for worker nodes"
  type        = string
}

variable "worker_location" {
  description = "Location for worker nodes"
  type        = list(string)
}

variable "worker_image" {
  description = "Image for worker nodes"
  type        = string
}
