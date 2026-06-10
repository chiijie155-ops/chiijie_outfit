variable "environment" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

resource "aws_security_group" "db" {
  name        = "${var.environment}-db-sg"
  description = "Security group for PostgreSQL RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow PostgreSQL access from internal VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-db-sg"
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

resource "aws_db_instance" "this" {
  identifier              = "${var.environment}-ecommerce-db"
  engine                  = "postgres"
  engine_version          = "15.10"
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  storage_type            = "gp3"
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.db.id]
  multi_az                = true
  publicly_accessible     = false
  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = var.enable_kms ? true : false
  kms_key_id              = var.enable_kms ? aws_kms_key.this[0].arn : null
  tags = {
    Name        = "${var.environment}-ecommerce-db"
    Environment = var.environment
  }
}

resource "aws_kms_key" "this" {
  count       = var.enable_kms ? 1 : 0
  description = "RDS encryption key for ${var.environment}"
  deletion_window_in_days = 30
  tags = {
    Name        = "${var.environment}-rds-kms"
    Environment = var.environment
  }
}

output "db_endpoint" {
  value = aws_db_instance.this.address
}

output "db_port" {
  value = aws_db_instance.this.port
}

output "db_instance_identifier" {
  value = aws_db_instance.this.id
}
