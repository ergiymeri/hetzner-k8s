variable "lb_name" {
  description = "Load Balancer Name"
  type        = string
}

variable "lb_type" {
  description = "Type of load balancer depending on the resources that you want"
  type        = string
}

variable "lb_location" {
  description = "Load balancer location"
  type        = string
}

variable "lb_private_ip" {
  description = "Load balancer private subnet ip"
  type        = string
}

variable "network_id" {
  description = "ID of the network"
  type        = string
}

variable "label_vms" {
  type = map(string)
}