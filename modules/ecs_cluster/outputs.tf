output "cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "cluster_id" {
  value = aws_ecs_cluster.main.name
}