resource "aws_ecr_repository" "main" {
  name                 = "${var.name}-${var.environment}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

output "container_image_name" {
  value = aws_ecr_repository.main.name
}

output "container_image_url" {
  value = aws_ecr_repository.main.repository_url
}