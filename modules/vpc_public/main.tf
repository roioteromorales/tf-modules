provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

resource "aws_vpc" "main" {
  cidr_block = var.cidr

  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public" {
  count = length(var.availability_zones)
  cidr_block = cidrsubnet(var.cidr, 3, 3 + count.index)
  vpc_id = aws_vpc.main.id
  availability_zone = "${var.region}${element(var.availability_zones, count.index)}"

  tags = {
    Name = "${var.name}-public-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)
  route_table_id = aws_default_route_table.default_route_table.id
  subnet_id = element(aws_subnet.public.*.id, count.index)
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.name
  }
}

resource "aws_route" "public_to_internet" {
  count = length(var.availability_zones)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
  route_table_id = element(aws_default_route_table.default_route_table.*.id, count.index)
}
