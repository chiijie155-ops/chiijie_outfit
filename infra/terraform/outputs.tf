output "cluster_name" {
  value = module.eks.cluster_name
}

output "db_endpoint" {
  value = module.rds.db_endpoint
}

output "redis_address" {
  value = module.redis.endpoint
}

output "app_image_repository" {
  value = module.app.image_repository
}
