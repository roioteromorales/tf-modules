output "lb_id" {
  value = aws_lb.main.id
}

output "lb_arn" {
  value = aws_lb.main.arn
}

output "lb_name" {
  value = aws_lb.main.name
}

output "lb_https_listener" {
  value = aws_lb_listener.main.arn
}
