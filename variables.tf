variable "availability_zone" {
  default = "eu-west-2a"
}

variable "backup_availability_zone" {
  default = "eu-west-2b"
}

variable "aws_region" {
  default = "eu-west-2"
}

variable "profile" {
  default = "terraform"
}

variable "environment" {
  default = "infosec_aws"
}

variable "t2small_instance_type" {
  default = "t2.small"
}

variable "t2medium_instance_type" {
  default = "t2.medium"
}

variable "t2large_instance_type" {
  default = "t2.large"
}

variable "t3large_instance_type" {
  default = "t3.large"
}

variable "m4large_instance_type" {
  default = "m4.large"
}

variable "key_name" {
  default = "informationsecurity-terraform"
}

variable "instance_ami" {
  default = "ami-XXX"
}

variable "nessus_instance_ami" {
  default = "ami-XXX"
}

variable "burpagent_instance_ami" {
  default = "ami-XXX"
}

variable "burpent_instance_ami" {
  default = "ami-XXX"
}

variable "sonarqube_instance_ami" {
  default = "ami-XXX"
}

variable "dtrack_instance_ami" {
  default = "ami-XXX"
}

variable "anchore_instance_ami" {
  default = "ami-XXX"
}

variable "terraform_instance_ami" {
  default = "ami-XXX"
}

variable "raneto_instance_ami" {
  default = "ami-XXX"
}

variable "iam_instance_profile" {
  default = "AmazonEC2RoleforSSM"
}

variable "volume_type" {
  default = "gp2"
}

variable "volume_size" {
  default = 50
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "internet_cidr" {
  default = "0.0.0.0/0"
}

variable "public_cidr" {
  default = "10.0.1.0/24"
}

variable "private_cidr" {
  default = "10.0.2.0/24"
}

variable "backup_private_cidr" {
  default = "10.0.5.0/24"
}

variable "jumpbox_private_ip" {
  default = "10.0.1.250"
}

variable "burpagent_private_ip" {
  default = "10.0.2.200"
}

variable "hive_private_ip" {
  default = "10.0.2.150"
}

variable "cortex_private_ip" {
  default = "10.0.2.151"
}

variable "jumpbox_ip" {
  default = "10.0.1.250/32"
}

variable "proxy_ip" {
  default = "10.0.1.89/32"
}

variable "jumpbox_hostname" {
  default = "jumpy.example.com"
}

variable "puppetmaster_hostname" {
  default = "pm.example.com"
}

variable "terraform_hostname" {
  default = "terraform.example.com"
}

variable "scoutsuite_hostname" {
  default = "ss.example.com"
}

variable "puppetmaster_private_ip" {
  default = "10.0.2.254"
}

variable "mailserver_private_ip" {
  default = "10.0.1.200"
}

variable "mailserver_hostname" {
  default = "mailserver.example.com"
}

variable "flashpaper_hostname" {
  default = "flashpaper.example.com"
}

variable "vulnreport_hostname" {
  default = "vulnreport.example.com"
}

variable "office_ip" {
  default = "192.168.1.100/32"
}

variable "the_world" {
  default = "0.0.0.0/0"
}

variable "tcp_protocol" {
  default = "tcp"
}

variable "ssh_port" {
  default = "22"
}

variable "smtp_port" {
  default = "25"
}

variable "http_port" {
  default = "80"
}

variable "https_port" {
  default = "443"
}

variable "mysql_port" {
  default = "3306"
}

variable "postgres_port" {
  default = "5432"
}

variable "grr_client_port" {
  default = "8080"
}

variable "grr_admin_port" {
  default = "8000"
}

variable "dtrack_port" {
  default = "8080"
}

variable "scoutsuite_port" {
  default = "8000"
}

variable "fleet_port" {
  default = "8000"
}

variable "nessus_port" {
  default = "8834"
}

variable "burp_api_port" {
  default = "8072"
}

variable "burp_db_port" {
  default = "9092"
}

variable "vsaq_port" {
  default = "8000"
}

variable "anchore_port" {
  default = "8228"
}

variable "flashpaper_port" {
  default = "8443"
}

variable "vulnreport_port" {
  default = "8000"
}

variable "sonarqube_port" {
  default = "9000"
}

variable "hive_port" {
  default = "9000"
}

variable "cortex_port" {
  default = "9001"
}

#
# RDS
#

variable "allocated_storage" {
  default = 20
}

variable "storage_type" {
  default = "gp2"
}

variable "engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "10"
}

variable "instance_class" {
  default = "db.t2.small"
}

variable "misp_instance_class" {
  default = "db.t3.large"
}

variable "publicly_accessible" {
  default = false
}

variable "backup_retention_period" {
  default = 5
}

variable "storage_encrypted" {
  default = true
}

variable "auto_minor_version_upgrade" {
  default = true
}

#
# GRR RDS
#

variable "grr_identifier" {
  default = "grr"
}

variable "grr_name" {
  default = "grr"
}

variable "grr_username" {
  default = "grr"
}

variable "grr_password" {
  default = "LOLNOPE"
}

#
# Burp Enterprise RDS
#

variable "burpent_identifier" {
  default = "burpenterprise"
}

variable "burpent_name" {
  default = "burpenterprise"
}

variable "burpent_username" {
  default = "burp"
}

variable "burpent_password" {
  default = "LOLNOPE"
}

#
# Sonarqube RDS
#

variable "sonarqube_identifier" {
  default = "sonarqube"
}

variable "sonarqube_name" {
  default = "sonarqube"
}

variable "sonarqube_username" {
  default = "sq"
}

variable "sonarqube_password" {
  default = "LOLNOPE"
}

#
# Dependency Track RDS
#

variable "dtrack_identifier" {
  default = "dtrack"
}

variable "dtrack_name" {
  default = "dtrack"
}

variable "dtrack_username" {
  default = "sq"
}

variable "dtrack_password" {
  default = "LOLNOPE"
}

# MISP RDS
#

variable "mysql_engine" {
  default = "mysql"
}

variable "mysql_engine_version" {
  default = "5.7.23"
}

variable "misp_allocated_storage" {
  default = 400
}

variable "misp_identifier" {
  default = "misp"
}

variable "misp_name" {
  default = "misp"
}

variable "misp_username" {
  default = "misp"
}

variable "misp_password" {
  default = "LOLNOPE"
}

#
# VulnReport RDS
#

variable "vulnreport_identifier" {
  default = "vulnreport"
}

variable "vulnreport_name" {
  default = "vulnreport"
}

variable "vulnreport_username" {
  default = "vr"
}

variable "vulnreport_password" {
  default = "LOLNOPE"
}

#
# EBS
#

variable "misp_volume_az" {
  default = "eu-west-2a"
}

variable "misp_volume_type" {
  default = "gp2"
}

variable "misp_volume_size" {
  default = "500"
}

variable "misp_volume_name" {
  default = "mispdata"
}

variable "misp_device_name" {
  default = "/dev/sdh"
}

#
# KMS
#

variable "misp_kms_key_name" {
  default = "alias/misp_volume_key"
}
