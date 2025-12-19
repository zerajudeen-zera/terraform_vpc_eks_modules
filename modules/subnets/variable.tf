variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cidr_block" {
  description = "Subnet CIDR"
  type        = string
}

variable "az" {
  description = "Availability Zone"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Public subnet flag"
  type        = bool
}

variable "name" {
  description = "Subnet name"
  type        = string
}