variable "vpc_id" {}

variable "subnets" {
  type = list(string)
}

variable "inbound_security_groups" {
  type    = list(string)
  default = []
}

variable "db_identifier" {}

variable "allocated_storage" {
  default = 20
}

variable "max_allocated_storage" {
  default = 1000
}

variable "engine_version" {
  default = "11.8"
}

variable "db_instance_class" {
  default = "db.t2.micro"
}

variable "backup_retention_period" {
  default = 7
}
