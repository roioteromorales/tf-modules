variable "name" {}
variable "recovery_window_in_days" {}

resource "aws_secretsmanager_secret" "main" {
  name = var.name
  recovery_window_in_days = var.recovery_window_in_days
}

output "arn" {
  value = aws_secretsmanager_secret.main.arn
}
