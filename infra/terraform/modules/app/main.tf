variable "environment" {
  type = string
}

variable "repository_name" {
  type = string
}

resource "aws_ecr_repository" "app" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name        = var.repository_name
    Environment = var.environment
  }
}

output "image_repository" {
  value = aws_ecr_repository.app.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.app.arn
}
