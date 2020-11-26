provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "main" {
  name = var.name

  setting {
    name = "containerInsights"
    value = var.containerInsights
  }
}