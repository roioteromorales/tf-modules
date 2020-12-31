resource "aws_security_group" "db" {
  vpc_id = var.vpc_id
  name = "${var.db_identifier}-security-group"
  description = "Security group for the ${var.db_identifier} db"

  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [
      var.inbound_security_groups
    ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = [
      "name",
      "description",
    ]
  }
}

resource "aws_db_subnet_group" "db" {
  name = "${var.db_identifier}-db-subnet"
  description = "RDS ${var.db_identifier} subnet group"
  subnet_ids = [
    var.subnets
  ]

  lifecycle {
    ignore_changes = [
      "name",
      "description",
    ]
  }
}

resource "aws_db_instance" "db" {
  identifier = var.db_identifier
  instance_class = var.db_instance_class
  allocated_storage = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type = "gp2"
  engine = "postgres"
  engine_version = var.engine_version
  name = "postgres"
  username = "master"
  password = "CHANGEME"
  backup_retention_period = var.backup_retention_period
  deletion_protection = true
  storage_encrypted = true
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.db_identifier}-SNAPSHOT"
  vpc_security_group_ids = [
    aws_security_group.db.id
  ]
  db_subnet_group_name = aws_db_subnet_group.db.name
  multi_az = true
  delete_automated_backups = false

  lifecycle {
    ignore_changes = [
      "username",
      "password",
      "multi_az",
    ]
  }

  tags = {
    BACKUP_ENABLED = "true"
  }
}

output "db_arn" {
  value = aws_db_instance.db.arn
}

output "db_address" {
  value = aws_db_instance.db.address
}

output "db_port" {
  value = aws_db_instance.db.port
}