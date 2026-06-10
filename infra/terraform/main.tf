terraform {
  backend "s3" {
    bucket = "chiijie-outfit-terraform-state"
    key    = "infra/terraform/terraform.tfstate"
    region = var.aws_region
  }
}

module "network" {
  source      = "./modules/network"
  environment = var.environment
}

module "eks" {
  source       = "./modules/eks"
  environment  = var.environment
  cluster_name = var.cluster_name
  vpc_id       = module.network.vpc_id
  subnet_ids   = module.network.private_subnet_ids
  instance_types = var.eks_instance_types
  desired_size   = var.eks_desired_size
  min_size       = var.eks_min_size
  max_size       = var.eks_max_size
}

module "rds" {
  source      = "./modules/rds"
  environment = var.environment
  db_username = var.db_username
  db_password = var.db_password
  vpc_id      = module.network.vpc_id
  subnet_ids  = module.network.private_subnet_ids
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  enable_kms        = var.enable_kms
}

module "redis" {
  source      = "./modules/redis"
  environment = var.environment
  vpc_id      = module.network.vpc_id
  subnet_ids  = module.network.private_subnet_ids
  node_type             = var.redis_node_type
  number_cache_clusters = var.redis_number_cache_clusters
  enable_kms            = var.enable_kms
}

module "app" {
  source          = "./modules/app"
  environment     = var.environment
  repository_name = "chiijie-outfit-app"
}
