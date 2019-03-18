variable "rds_sg" {}
variable "db_subnet_group_name" {}
variable "allocated_storage" {}
variable "misp_allocated_storage" {}
variable "storage_type" {}
variable "engine" {}
variable "mysql_engine" {}
variable "engine_version" {}
variable "mysql_engine_version" {}
variable "instance_class" {}
variable "misp_instance_class" {}
variable "publicly_accessible" {}
variable "backup_retention_period" {}
variable "auto_minor_version_upgrade" {}
variable "storage_encrypted" {}
variable "grr_identifier" {}
variable "grr_name" {}
variable "grr_username" {}
variable "grr_password" {}
variable "burpent_identifier" {}
variable "burpent_name" {}
variable "burpent_username" {}
variable "burpent_password" {}
variable "sonarqube_identifier" {}
variable "sonarqube_name" {}
variable "sonarqube_username" {}
variable "sonarqube_password" {}
variable "dtrack_identifier" {}
variable "dtrack_name" {}
variable "dtrack_username" {}
variable "dtrack_password" {}
variable "misp_identifier" {}
variable "misp_name" {}
variable "misp_username" {}
variable "misp_password" {}
variable "vulnreport_identifier" {}
variable "vulnreport_name" {}
variable "vulnreport_username" {}
variable "vulnreport_password" {}

variable "security_groups" {
  type = "list"
}

#
# GRR
#

resource "aws_db_instance" "grr_rds" {
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  allocated_storage          = "${var.allocated_storage}"
  storage_type               = "${var.storage_type}"
  engine                     = "${var.mysql_engine}"
  engine_version             = "${var.mysql_engine_version}"
  instance_class             = "${var.instance_class}"
  identifier                 = "${var.grr_identifier}"
  name                       = "${var.grr_name}"
  username                   = "${var.grr_username}"
  password                   = "${var.grr_password}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  storage_encrypted          = "${var.storage_encrypted}"
  publicly_accessible        = "${var.publicly_accessible}"
  backup_retention_period    = "${var.backup_retention_period}"
  vpc_security_group_ids     = ["${var.rds_sg}"]

  tags {
    Name = "GRR Database"
  }
}

output "grr_rds_endpoint" {
  value = "${aws_db_instance.grr_rds.address}"
}

#
# Burp Suite Enterprise
#

resource "aws_db_instance" "burpenterprise_rds" {
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  allocated_storage          = "${var.allocated_storage}"
  storage_type               = "${var.storage_type}"
  engine                     = "${var.engine}"
  engine_version             = "${var.engine_version}"
  instance_class             = "${var.instance_class}"
  identifier                 = "${var.burpent_identifier}"
  name                       = "${var.burpent_name}"
  username                   = "${var.burpent_username}"
  password                   = "${var.burpent_password}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  storage_encrypted          = "${var.storage_encrypted}"
  publicly_accessible        = "${var.publicly_accessible}"
  backup_retention_period    = "${var.backup_retention_period}"
  vpc_security_group_ids     = ["${var.rds_sg}"]

  tags {
    Name = "Burp Enterprise Database"
  }
}

output "burpenterprise_rds_endpoint" {
  value = "${aws_db_instance.burpenterprise_rds.address}"
}

#
# dtrack
#

resource "aws_db_instance" "sonarqube_rds" {
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  allocated_storage          = "${var.allocated_storage}"
  storage_type               = "${var.storage_type}"
  engine                     = "${var.engine}"
  engine_version             = "${var.engine_version}"
  instance_class             = "${var.instance_class}"
  identifier                 = "${var.sonarqube_identifier}"
  name                       = "${var.sonarqube_name}"
  username                   = "${var.sonarqube_username}"
  password                   = "${var.sonarqube_password}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  storage_encrypted          = "${var.storage_encrypted}"
  publicly_accessible        = "${var.publicly_accessible}"
  backup_retention_period    = "${var.backup_retention_period}"
  vpc_security_group_ids     = ["${var.rds_sg}"]

  tags {
    Name = "SonarQube Database"
  }
}

output "sonarqube_rds_endpoint" {
  value = "${aws_db_instance.sonarqube_rds.address}"
}

#
# Dependency Tracker
#

resource "aws_db_instance" "dtrack_rds" {
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  allocated_storage          = "${var.allocated_storage}"
  storage_type               = "${var.storage_type}"
  engine                     = "${var.engine}"
  engine_version             = "${var.engine_version}"
  instance_class             = "${var.instance_class}"
  identifier                 = "${var.dtrack_identifier}"
  name                       = "${var.dtrack_name}"
  username                   = "${var.dtrack_username}"
  password                   = "${var.dtrack_password}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  storage_encrypted          = "${var.storage_encrypted}"
  publicly_accessible        = "${var.publicly_accessible}"
  backup_retention_period    = "${var.backup_retention_period}"
  vpc_security_group_ids     = ["${var.rds_sg}"]

  tags {
    Name = "Deptrack Database"
  }
}

output "dtrack_rds_endpoint" {
  value = "${aws_db_instance.dtrack_rds.address}"
}

#
# MISP
#

resource "aws_db_instance" "misp_rds" {
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  allocated_storage          = "${var.misp_allocated_storage}"
  engine                     = "${var.mysql_engine}"
  engine_version             = "${var.mysql_engine_version}"
  instance_class             = "${var.misp_instance_class}"
  identifier                 = "${var.misp_identifier}"
  name                       = "${var.misp_name}"
  username                   = "${var.misp_username}"
  password                   = "${var.misp_password}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  storage_encrypted          = "${var.storage_encrypted}"
  publicly_accessible        = "${var.publicly_accessible}"
  backup_retention_period    = "${var.backup_retention_period}"
  vpc_security_group_ids     = ["${var.rds_sg}"]

  tags {
    Name = "MISP Database"
  }
}

output "misp_rds_endpoint" {
  value = "${aws_db_instance.misp_rds.address}"
}

#
# Vuln Report
#

resource "aws_db_instance" "vulnreport_rds" {
  db_subnet_group_name       = "${var.db_subnet_group_name}"
  allocated_storage          = "${var.allocated_storage}"
  storage_type               = "${var.storage_type}"
  engine                     = "${var.engine}"
  engine_version             = "${var.engine_version}"
  instance_class             = "${var.instance_class}"
  identifier                 = "${var.vulnreport_identifier}"
  name                       = "${var.vulnreport_name}"
  username                   = "${var.vulnreport_username}"
  password                   = "${var.vulnreport_password}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  storage_encrypted          = "${var.storage_encrypted}"
  publicly_accessible        = "${var.publicly_accessible}"
  backup_retention_period    = "${var.backup_retention_period}"
  vpc_security_group_ids     = ["${var.rds_sg}"]

  tags {
    Name = "VulnReport Database"
  }
}

output "vulnreport_rds_endpoint" {
  value = "${aws_db_instance.vulnreport_rds.address}"
}
