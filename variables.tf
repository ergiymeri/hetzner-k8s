variable "hcloud_token" {
  description = "Hetzner Cloud API token"
  sensitive   = true
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "k8s-cluster"
}

variable "label_vms" {
  type = map(string)
  default = {
    cluster      = "cluster"
    cluster_name = "hcloud-k8s-cluster"
    controlplane = "controlplane"
    worker       = "worker"
    vpn          = "vpn"
    role         = "role"
  }
}

variable "direction" {
  description = "Firewall Direction rule"
  type        = map(string)
  default = {
    in  = "in"
    out = "out"
  }
}

variable "protocol" {
  description = "Firewall Protocol Type"
  type        = map(string)
  default = {
    icmp = "icmp"
    tcp  = "tcp"
    udp  = "udp"
  }
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "k8s-cluster-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
  default     = "172.16.0.0/24"
}

variable "subnet_type" {
  description = "Type of subnet"
  type        = string
  default     = "cloud"
}

variable "network_zone" {
  description = "Network Zone"
  type        = string
  default     = "eu-central"
}

variable "ssh_key_name" {
  description = "Name of the SSH key in Hetzner Cloud"
  type        = string
  default     = "hetzner-k8s"
}

variable "ssh_port" {
  description = "SSH port that you connect to the server"
  type        = string
  default     = "22"
}


variable "private_key_path" {
  description = "Path to the private SSH key file"
  type        = string
  default     = "./keys/hetzner-k8s"
}

# Master node variables
variable "master_count" {
  description = "Number of master nodes"
  type        = number
  default     = 3
}

variable "master_server_type" {
  description = "Server type for master nodes"
  type        = string
  default     = "cpx11"
}

variable "master_location" {
  description = "Location for master nodes"
  type        = list(string)
  default     = ["nbg1", "fsn1", "hel1"]
}

variable "master_image" {
  description = "Image for master nodes"
  type        = string
  default     = "ubuntu-24.04"
}

# Worker node variables
variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
}

variable "worker_server_type" {
  description = "Server type for worker nodes"
  type        = string
  default     = "cpx11"
}

variable "worker_location" {
  description = "Location for worker nodes"
  type        = list(string)
  default     = ["nbg1", "fsn1", "hel1"]
}

variable "worker_image" {
  description = "Image for worker nodes"
  type        = string
  default     = "ubuntu-24.04"
}


variable "lb_name" {
  description = "Load Balancer Name"
  type        = string
  default     = "controlplane-lb"
}

variable "lb_type" {
  description = "Type of load balancer depending on the resources that you want"
  type        = string
  default     = "lb11"
}

variable "lb_location" {
  description = "Load balancer location"
  type        = string
  default     = "nbg1"
}

variable "lb_private_ip" {
  description = "Load balancer private subnet ip"
  type        = string
  default     = "172.16.0.10"
}

variable "vpn_server_type" {
  description = "Server type for vpn nodes"
  type        = string
  default     = "cpx11"
}

variable "vpn_hostname" {
  description = "VPN node name"
  type        = string
  default     = "wg-vpn"
}


variable "vpn_location" {
  description = "Location for vpn nodes"
  type        = string
  default     = "fsn1"
}

variable "vpn_image" {
  description = "Image for vpn nodes"
  type        = string
  default     = "ubuntu-24.04"
}

variable "vpn_private_ip" {
  description = "VPN private subnet ip"
  type        = string
  default     = "172.16.0.20"
}