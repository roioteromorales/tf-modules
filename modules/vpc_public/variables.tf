variable "name" {}

variable "region" {}

variable "cidr" {
  description = "Classless Inter-Domain Routing, eg.: 172.10.0.0/20"
}

variable "availability_zones" {
  default = [
    "a",
    "b"
  ]
}