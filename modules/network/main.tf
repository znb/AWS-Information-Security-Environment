variable "availability_zone" {}
variable "backup_availability_zone" {}
variable "vpc_cidr" {}
variable "internet_cidr" {}
variable "public_cidr" {}
variable "private_cidr" {}
variable "backup_private_cidr" {}

#
# VPC
#

resource "aws_vpc" "infosec_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = false

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "infosec_vpc"
  }
}

output "vpc_id" {
  value = "${aws_vpc.infosec_vpc.id}"
}

#
# Gateways
#

resource "aws_internet_gateway" "infosec_igw" {
  vpc_id = "${aws_vpc.infosec_vpc.id}"

  tags {
    Name = "infosec_vpc_internet_gateway"
  }
}

resource "aws_nat_gateway" "infosec_ngw" {
  allocation_id = "${aws_eip.infosec_eip.id}"
  subnet_id     = "${aws_subnet.public_subnet.id}"
  depends_on    = ["aws_internet_gateway.infosec_igw"]

  tags {
    Name = "infosec_vpc_nat_gateway"
  }
}

#
# EIP
#

resource "aws_eip" "infosec_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.infosec_igw"]

  tags {
    Name = "infosec_vpc_eip"
  }
}

#
# Subnets
#

resource "aws_subnet" "public_subnet" {
  vpc_id                  = "${aws_vpc.infosec_vpc.id}"
  cidr_block              = "${var.public_cidr}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_internet_gateway.infosec_igw"]

  tags {
    Name = "infosec_public_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "public_subnet_id" {
  value = "${aws_subnet.public_subnet.id}"
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = "${aws_vpc.infosec_vpc.id}"
  cidr_block              = "${var.private_cidr}"
  availability_zone       = "${var.availability_zone}"
  map_public_ip_on_launch = true

  # depends_on              = ["aws_nat_gateway.infosec_ngw"]

  tags {
    Name = "infosec_private_subnet"
  }
  lifecycle {
    create_before_destroy = true
  }
}

output "private_subnet_id" {
  value = "${aws_subnet.private_subnet.id}"
}

resource "aws_subnet" "backup_private_subnet" {
  vpc_id                  = "${aws_vpc.infosec_vpc.id}"
  cidr_block              = "${var.backup_private_cidr}"
  availability_zone       = "${var.backup_availability_zone}"
  map_public_ip_on_launch = true
  depends_on              = ["aws_nat_gateway.infosec_ngw"]

  tags {
    Name = "infosec_backup_private_subnet"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "backup_private_subnet_id" {
  value = "${aws_subnet.backup_private_subnet.id}"
}

#
# RDS Subnets
#

resource "aws_db_subnet_group" "rds_subnet" {
  name = "db_rds_subnet"

  subnet_ids = ["${aws_subnet.private_subnet.id}",
    "${aws_subnet.backup_private_subnet.id}",
  ]

  tags {
    Name = "infosec_rds_subnet_group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "db_subnet_group" {
  value = "${aws_db_subnet_group.rds_subnet.id}"
}

#
# Route Tables
#

resource "aws_route" "nat_default_routes" {
  route_table_id         = "${aws_route_table.private_route_table.id}"
  destination_cidr_block = "${var.internet_cidr}"
  nat_gateway_id         = "${aws_nat_gateway.infosec_ngw.id}"
}

resource "aws_route" "default_route" {
  route_table_id         = "${aws_route_table.public_route_table.id}"
  destination_cidr_block = "${var.internet_cidr}"
  gateway_id             = "${aws_internet_gateway.infosec_igw.id}"
}

resource "aws_route_table" "public_route_table" {
  vpc_id = "${aws_vpc.infosec_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.infosec_igw.id}"
  }

  tags {
    Name = "infosec_vpc_public_route_table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = "${aws_vpc.infosec_vpc.id}"

  tags {
    Name = "infosec_vpc_private_route_table"
  }
}

resource "aws_route_table_association" "public_rta" {
  subnet_id      = "${aws_subnet.public_subnet.id}"
  route_table_id = "${aws_route_table.public_route_table.id}"
}

resource "aws_route_table_association" "private_rta" {
  subnet_id      = "${aws_subnet.private_subnet.id}"
  route_table_id = "${aws_route_table.private_route_table.id}"
}
