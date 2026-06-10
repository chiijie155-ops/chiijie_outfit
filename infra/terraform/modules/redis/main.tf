variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

resource "aws_security_group" "redis" {
  name        = "${var.environment}-redis-sg"
  description = "Security group for Redis cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow internal VPC access to Redis"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-redis-sg"
    Environment = var.environment
  }
}

resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.environment}-redis-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name        = "${var.environment}-redis-subnet-group"
    Environment = var.environment
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.environment}-redis-rg"
  replication_group_description = "Redis replication group for ${var.environment}"
  node_type                     = var.node_type
  number_cache_clusters         = var.number_cache_clusters
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  security_group_ids            = [aws_security_group.redis.id]
  automatic_failover_enabled    = false
  transit_encryption_enabled    = true
  at_rest_encryption_enabled    = var.enable_kms ? true : false
  kms_key_id                    = var.enable_kms ? aws_kms_key.this[0].arn : null
  apply_immediately             = true
  engine                        = "redis"
  engine_version                = "7.0"
  tags = {
    Name        = "${var.environment}-redis"
    Environment = var.environment
  }
}

resource "aws_kms_key" "this" {
  count       = var.enable_kms ? 1 : 0
  description = "ElastiCache KMS key for ${var.environment}"
  deletion_window_in_days = 30
  tags = {
    Name        = "${var.environment}-redis-kms"
    Environment = var.environment
  }
}

output "endpoint" {
  value = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "replication_group_id" {
  value = aws_elasticache_replication_group.this.id
}
