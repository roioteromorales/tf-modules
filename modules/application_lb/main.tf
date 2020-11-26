resource "aws_lb" "main" {
  name = var.name
  internal = false
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.main.id
  ]
  subnets = var.subnets
  enable_deletion_protection = false
}

resource "aws_security_group" "main" {
  name = var.name
  description = var.name
  vpc_id = var.vpc_id
  ingress {
    description = "Permit all from outside"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    description = "Permit all from outside securely"
    from_port = 443
    to_port = 443
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
}