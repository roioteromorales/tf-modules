output "aws_ecs_task_definition_revision" {
  value = aws_ecs_task_definition.main.revision
}
output "task_security_group_id" {
  value = aws_security_group.main.id
}
