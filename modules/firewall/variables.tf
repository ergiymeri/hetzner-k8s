variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "direction" {
  description = "Firewall Direction rule"
  type = map(string)
}

variable "protocol" {
  description = "Firewall Protocol Type"
  type = map(string)
}

variable "source_ip" {
  description = "Source IP for firewall to accept request"
  type = string
}

variable "ssh_port" {
  description = "SSH port that you connect to the server"
  type = string
}

variable "label_vms" {
  type = map(string)
}

