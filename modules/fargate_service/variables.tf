variable "vpc_id" {}
variable "subnets" {}
variable "cluster_id" {}
variable "service_name" {}
variable "region" {}
variable "repository_name" {}
variable "repository_version" {
  default = "latest"
}
variable "ecs_execution_role_arn" {}
variable "lb_arn" {}
variable "lb_path" {}
variable "acm_certificate_arn" {}
variable "health_check_url_path" {}

variable "assign_public_ip" {
  type = bool
  default = false
}

variable "cpu" {
  default = 256
}

variable "memory" {
  default = 512
}

variable "container_port" {
  default = 8080
}

variable "min_instances" {
  default = 1
}

variable "environment_variables" {
  description = "Service's environment variables (JSON array)"
  default = "[]"
}

variable "aws_iam_role" {
  description = "Service's policy"
  default = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    }
  ]
}
EOF
}
