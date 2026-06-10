variable "aws_region" {
  type        = string
  description = "AWS region for infrastructure deployment"
  default     = "ap-southeast-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "staging"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "chiijie-outfit-cluster"
}

variable "db_username" {
  type        = string
  description = "PostgreSQL database username"
  default     = "ecommerce_user"
}

variable "db_password" {
  type        = string
  description = "PostgreSQL database password"
  default     = "changeme123"
  sensitive   = true
}

variable "kubernetes_host" {
  type        = string
  description = "Kubernetes API server endpoint"
  default     = ""
}

variable "kubernetes_token" {
  type        = string
  description = "Kubernetes bearer token for provider"
  default     = ""
  sensitive   = true
}

variable "kubernetes_ca_certificate" {
  type        = string
  description = "Base64-encoded Kubernetes CA certificate"
  default     = ""
  sensitive   = true
}

variable "eks_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "eks_desired_size" {
  type    = number
  default = 2
}

variable "eks_min_size" {
  type    = number
  default = 2
}

variable "eks_max_size" {
  type    = number
  default = 4
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.medium"
}

variable "rds_allocated_storage" {
  type    = number
  default = 100
}

variable "redis_node_type" {
  type    = string
  default = "cache.t4g.small"
}

variable "redis_number_cache_clusters" {
  type    = number
  default = 1
}

variable "enable_kms" {
  type    = bool
  default = false
}
