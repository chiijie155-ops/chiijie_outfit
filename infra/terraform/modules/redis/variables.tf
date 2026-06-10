variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "node_type" {
  type    = string
  default = "cache.t4g.small"
}

variable "number_cache_clusters" {
  type    = number
  default = 1
}

variable "enable_kms" {
  type    = bool
  default = false
}
variable "environment" {
  type        = string
  description = "Deployment environment name"
}
