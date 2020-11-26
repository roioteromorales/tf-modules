variable "name" {}

variable "mutability" {
  description = "[MUTABLE|IMMUTABLE]"
  default = "MUTABLE"
}

variable "image_scanning" {
  default = true
}

resource "aws_ecr_repository" "main" {
  name = var.name
  image_tag_mutability = var.mutability

  image_scanning_configuration {
    scan_on_push = var.image_scanning
  }
}

output "ecr_arn" {
  value = aws_ecr_repository.main.arn
}

output "ecr_name" {
  value = aws_ecr_repository.main.name
}

output "ecr_registry_id" {
  value = aws_ecr_repository.main.registry_id
}

output "ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}