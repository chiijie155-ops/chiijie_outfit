output "image_repository" {
  value = aws_ecr_repository.app.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.app.arn
}
