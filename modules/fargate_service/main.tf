provider "aws" {
  region = var.region
}

locals {
  container_definitions = <<EOF
[
  {
    "name": "${var.service_name}",
    "image": "${var.repository}",
    "environment": ${var.environment_variables},
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.service_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs"
        }
    },
    "portMappings": [
      {
        "containerPort": ${var.port}
      }
    ]
  }
]
EOF
}

resource "aws_cloudwatch_log_group" "main" {
  name = var.service_name
}

resource "aws_ecs_task_definition" "main" {
  family = var.service_name
  requires_compatibilities = [
    "FARGATE"
  ]
  network_mode = "awsvpc"
  cpu = var.cpu
  memory = var.memory
  container_definitions = local.container_definitions
  task_role_arn = aws_iam_role.main.arn
  execution_role_arn = var.ecs_execution_role_arn
}

resource "aws_ecs_service" "main" {
  name = var.service_name
  cluster = var.cluster_id
  task_definition = "${aws_ecs_task_definition.main.family}:${aws_ecs_task_definition.main.revision}"
  desired_count = var.min_instances
  launch_type = "FARGATE"

  network_configuration {
    subnets = var.subnets
    security_groups = [
      aws_security_group.main.id
    ]
    assign_public_ip = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name = var.service_name
    container_port = var.port
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition
    ]
  }
}

resource "aws_iam_policy_attachment" "main" {
  name = var.service_name
  policy_arn = aws_iam_policy.main.arn
  roles = [
    aws_iam_role.main.name,
  ]
}

resource "aws_iam_role" "main" {
  name = var.service_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "main" {
  name = var.service_name
  policy = <<EOF
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

resource "aws_security_group" "main" {
  name = var.service_name
  description = var.service_name
  vpc_id = var.vpc_id

  ingress {
    description = "Permit all from outside"
    from_port = var.port
    to_port = var.port
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  egress {
    description = "Permit all from inside"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name = var.service_name
  }
}

resource "aws_lb_target_group" "main" {
  name = var.service_name
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id = var.vpc_id
  health_check {
    enabled = true
    interval = 120
    port = 80
    path = var.health_check_url_path
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = var.lb_arn
  port = "80"
  protocol = "HTTP"
  ssl_policy = "ELBSecurityPolicy-2016-08"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

//resource "aws_lb_listener" "redirect_http_to_https" {
//  load_balancer_arn = var.lb_arn
//  port = "80"
//  protocol = "HTTP"
//
//  default_action {
//    type = "redirect"
//
//    redirect {
//      port = "443"
//      protocol = "HTTPS"
//      status_code = "HTTP_301"
//    }
//  }
//}

resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.main.arn
  priority = 100

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = [
        var.lb_path
      ]
    }
  }

}

//resource "aws_lb_listener_rule" "redirect_http_to_https" {
//  listener_arn = aws_lb_listener.redirect_http_to_https.arn
//
//  action {
//    type = "redirect"
//
//    redirect {
//      port = "443"
//      protocol = "HTTPS"
//      status_code = "HTTP_301"
//    }
//  }
//
//  condition {
//    http_header {
//      http_header_name = "X-Forwarded-For"
//      values = [
//        var.lb_path
//      ]
//    }
//  }
//}