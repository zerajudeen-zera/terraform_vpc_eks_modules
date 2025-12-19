variable "cluster_name" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "cluster_role_depends_on" {
  type = any
}