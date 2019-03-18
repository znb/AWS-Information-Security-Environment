variable "environment" {}
variable "vpc_cidr" {}
variable "vpc_id" {}
variable "public_cidr" {}
variable "tcp_protocol" {}
variable "ssh_port" {}
variable "smtp_port" {}
variable "http_port" {}
variable "https_port" {}
variable "nessus_port" {}
variable "mysql_port" {}
variable "postgres_port" {}
variable "grr_client_port" {}
variable "grr_admin_port" {}
variable "burp_api_port" {}
variable "burp_db_port" {}
variable "vsaq_port" {}
variable "sonarqube_port" {}
variable "dtrack_port" {}
variable "anchore_port" {}
variable "hive_port" {}
variable "cortex_port" {}
variable "scoutsuite_port" {}
variable "flashpaper_port" {}
variable "vulnreport_port" {}
variable "the_world" {}
variable "office_ip" {}
variable "jumpbox_ip" {}
variable "proxy_ip" {}

#
# Jumpbox
#

resource "aws_security_group" "jumpbox_sg" {
  name   = "jumpbox_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "jumpbox_ssh_ingress" {
  type              = "ingress"
  security_group_id = "${aws_security_group.jumpbox_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.the_world}"]
}

resource "aws_security_group_rule" "jumpbox_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.jumpbox_sg.id}"
  description       = "Allow everyone to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "jumpbox_sg" {
  value = "${aws_security_group.jumpbox_sg.id}"
}

#
# Proxy
#

resource "aws_security_group" "proxy_sg" {
  name   = "proxy_sg"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "proxy_allow_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.proxy_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.public_cidr}"]
}

resource "aws_security_group_rule" "proxy_allow_https" {
  type              = "ingress"
  security_group_id = "${aws_security_group.proxy_sg.id}"
  description       = "Allow incoming HTTPS"

  from_port = "${var.https_port}"
  to_port   = "${var.https_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.the_world}"]
}

resource "aws_security_group_rule" "proxy_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.proxy_sg.id}"
  description       = "Allow Mail Server to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "proxy_sg" {
  value = "${aws_security_group.proxy_sg.id}"
}

#
# Nessus Scanner
#

resource "aws_security_group" "nessus_sg" {
  name   = "nessus_scanner_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_nessus" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nessus_sg.id}"
  description       = "Allow incoming Nessus"

  from_port = "${var.nessus_port}"
  to_port   = "${var.nessus_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.office_ip}"]
}

resource "aws_security_group_rule" "allow_nessus_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.nessus_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "nessus_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.nessus_sg.id}"
  description       = "Allow instance to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "nessus_sg" {
  value = "${aws_security_group.nessus_sg.id}"
}

#
# Flashpaper
#

resource "aws_security_group" "flashpaper_sg" {
  name   = "infosec_flashpaper_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "flashpaper_allow_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.flashpaper_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "flashpaper_allow_proxy" {
  type              = "ingress"
  security_group_id = "${aws_security_group.flashpaper_sg.id}"
  description       = "Allow incoming HTTPS"

  from_port = "${var.flashpaper_port}"
  to_port   = "${var.flashpaper_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.office_ip}",
    "${var.proxy_ip}",
  ]
}

resource "aws_security_group_rule" "flashpaper_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.flashpaper_sg.id}"
  description       = "Allow instance to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "flashpaper_sg" {
  value = "${aws_security_group.flashpaper_sg.id}"
}

#
# Mail server
#

resource "aws_security_group" "mailserver_sg" {
  name   = "mailserver_sg"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_smtp" {
  type              = "ingress"
  security_group_id = "${aws_security_group.mailserver_sg.id}"
  description       = "Allow incoming SMTP"

  from_port = "${var.smtp_port}"
  to_port   = "${var.smtp_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_mailserver_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.mailserver_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_mailserver_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.mailserver_sg.id}"
  description       = "Allow instance to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "mailserver_sg" {
  value = "${aws_security_group.mailserver_sg.id}"
}

#
# VSAQ
#

resource "aws_security_group" "vsaq_sg" {
  name   = "infosec_vsaq_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_vsaq_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.vsaq_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_vsaq_proxy" {
  type              = "ingress"
  security_group_id = "${aws_security_group.vsaq_sg.id}"
  description       = "Allow incoming HTTPS from proxy"

  from_port = "${var.vsaq_port}"
  to_port   = "${var.vsaq_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.proxy_ip}"]
}

resource "aws_security_group_rule" "vsaq_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.vsaq_sg.id}"
  description       = "Allow instance to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "vsaq_sg" {
  value = "${aws_security_group.vsaq_sg.id}"
}

#
# RDS
#

resource "aws_security_group" "rds_sg" {
  name   = "rds_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_rds_postgres" {
  type              = "ingress"
  security_group_id = "${aws_security_group.rds_sg.id}"
  description       = "Allow incoming Postgres"

  from_port   = "${var.postgres_port}"
  to_port     = "${var.postgres_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_rds_mysql" {
  type              = "ingress"
  security_group_id = "${aws_security_group.rds_sg.id}"
  description       = "Allow incoming MySQL"

  from_port   = "${var.mysql_port}"
  to_port     = "${var.mysql_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_rds_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.rds_sg.id}"
  description       = "Allow RDS to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "rds_sg" {
  value = "${aws_security_group.rds_sg.id}"
}

#
# GRR Instance
#

resource "aws_security_group" "grr_sg" {
  name   = "grr_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_grr_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.grr_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_grr_clients" {
  type              = "ingress"
  security_group_id = "${aws_security_group.grr_sg.id}"
  description       = "Allow incoming client connections"

  from_port = "${var.grr_client_port}"
  to_port   = "${var.grr_client_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.proxy_ip}"]
}

resource "aws_security_group_rule" "allow_grr_admin" {
  type              = "ingress"
  security_group_id = "${aws_security_group.grr_sg.id}"
  description       = "Allow incoming admin connections"

  from_port = "${var.grr_admin_port}"
  to_port   = "${var.grr_admin_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.proxy_ip}"]
}

resource "aws_security_group_rule" "grr_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.grr_sg.id}"
  description       = "Allow instance to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "grr_sg" {
  value = "${aws_security_group.grr_sg.id}"
}

resource "aws_security_group" "grr_rds_sg" {
  name   = "grr_rds_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "grr_rds_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.grr_rds_sg.id}"
  description       = "Allow RDS RDS to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "grr_rds_sg" {
  value = "${aws_security_group.grr_rds_sg.id}"
}

#
# Burp Agent
#

resource "aws_security_group" "burpagent_sg" {
  name   = "burpagent_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_burpagent_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.burpagent_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_burpagent_api" {
  type              = "ingress"
  security_group_id = "${aws_security_group.burpagent_sg.id}"
  description       = "Allow incoming agent access to API"

  from_port   = "${var.burp_api_port}"
  to_port     = "${var.burp_api_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_burpagent_db" {
  type              = "ingress"
  security_group_id = "${aws_security_group.burpagent_sg.id}"
  description       = "Allow incoming agent access to database"

  from_port   = "${var.burp_db_port}"
  to_port     = "${var.burp_db_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_instance_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.burpagent_sg.id}"
  description       = "Allow burp to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "burpagent_sg" {
  value = "${aws_security_group.burpagent_sg.id}"
}

#
# Burp Enterprise
#

resource "aws_security_group" "burpent_sg" {
  name   = "burpent_instance_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_burpent_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.burpent_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_burpent_api" {
  type              = "ingress"
  security_group_id = "${aws_security_group.burpent_sg.id}"
  description       = "Allow incoming agent access to API"

  from_port   = "${var.burp_api_port}"
  to_port     = "${var.burp_api_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_burpent_db" {
  type              = "ingress"
  security_group_id = "${aws_security_group.burpent_sg.id}"
  description       = "Allow incoming agent access to database"

  from_port   = "${var.burp_db_port}"
  to_port     = "${var.burp_db_port}"
  protocol    = "${var.tcp_protocol}"
  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_burpent_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.burpent_sg.id}"
  description       = "Allow burp to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "burpent_sg" {
  value = "${aws_security_group.burpent_sg.id}"
}

#
# Sonarqube
#

resource "aws_security_group" "sonarqube_sg" {
  name   = "sonarqube_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_sonarqube_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.sonarqube_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_sonarqube" {
  type              = "ingress"
  security_group_id = "${aws_security_group.sonarqube_sg.id}"
  description       = "Allow incoming access to sonarqube"

  from_port = "${var.sonarqube_port}"
  to_port   = "${var.sonarqube_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.proxy_ip}"]
}

resource "aws_security_group_rule" "sonarqube_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.sonarqube_sg.id}"
  description       = "Allow dsonarqube to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "sonarqube_sg" {
  value = "${aws_security_group.sonarqube_sg.id}"
}

resource "aws_security_group" "sonarqube_rds_sg" {
  name   = "sonarqube_rds_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "sonarqube_rds_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.sonarqube_rds_sg.id}"
  description       = "Allow sonarqube RDS to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "sonarqube_rds_sg" {
  value = "${aws_security_group.sonarqube_rds_sg.id}"
}

#
# Dependency Track
#

resource "aws_security_group" "dtrack_sg" {
  name   = "dtrack_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_dtrack_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.dtrack_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_dtrack" {
  type              = "ingress"
  security_group_id = "${aws_security_group.dtrack_sg.id}"
  description       = "Allow incoming access to dtrack"

  from_port = "${var.dtrack_port}"
  to_port   = "${var.dtrack_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = [
    "${var.jenkins_dev_ip}",
    "${var.proxy_ip}",
  ]
}

resource "aws_security_group_rule" "dtrack_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.dtrack_sg.id}"
  description       = "Allow ddtrack to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "dtrack_sg" {
  value = "${aws_security_group.dtrack_sg.id}"
}

resource "aws_security_group" "dtrack_rds_sg" {
  name   = "dtrack_rds_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_dtrack_rds_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.dtrack_rds_sg.id}"
  description       = "Allow Dep Track RDS to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "dtrack_rds_sg" {
  value = "${aws_security_group.dtrack_rds_sg.id}"
}

#
# Anchore
#

resource "aws_security_group" "anchore_sg" {
  name   = "anchore_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_anchore_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.anchore_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "anchore_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.anchore_sg.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "anchore_sg" {
  value = "${aws_security_group.anchore_sg.id}"
}

#
# MISP
#

resource "aws_security_group" "misp_sg" {
  name   = "misp_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_misp_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.misp_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_misp_https" {
  type              = "ingress"
  security_group_id = "${aws_security_group.misp_sg.id}"
  description       = "Allow incoming HTTPS"

  from_port = "${var.https_port}"
  to_port   = "${var.https_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.proxy_ip}"]
}

resource "aws_security_group_rule" "misp_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.misp_sg.id}"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "misp_sg" {
  value = "${aws_security_group.misp_sg.id}"
}

resource "aws_security_group" "misp_rds_sg" {
  name   = "misp_rds_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_misp_rds_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.misp_rds_sg.id}"
  description       = "Allow MISP RDS to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "misp_rds_sg" {
  value = "${aws_security_group.misp_rds_sg.id}"
}

#
# Hive
#

resource "aws_security_group" "hive_sg" {
  name   = "hive_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_hive_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.hive_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_hive" {
  type              = "ingress"
  security_group_id = "${aws_security_group.hive_sg.id}"
  description       = "Allow incoming HTTP"

  from_port = "${var.hive_port}"
  to_port   = "${var.hive_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "allow_cortex" {
  type              = "ingress"
  security_group_id = "${aws_security_group.hive_sg.id}"
  description       = "Allow Hive to talk to Cortex"

  from_port = "${var.cortex_port}"
  to_port   = "${var.cortex_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "hive_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.hive_sg.id}"
  description       = "Allow Hive to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "hive_sg" {
  value = "${aws_security_group.hive_sg.id}"
}

#
# Scout Suite
#

resource "aws_security_group" "scoutsuite_sg" {
  name   = "infosec_scoutsuite_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_scoutsuite_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.scoutsuite_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "allow_scoutsuite_proxy" {
  type              = "ingress"
  security_group_id = "${aws_security_group.scoutsuite_sg.id}"
  description       = "Allow incoming HTTPS from proxy"

  from_port = "${var.scoutsuite_port}"
  to_port   = "${var.scoutsuite_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.proxy_ip}"]
}

resource "aws_security_group_rule" "scoutsuite_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.scoutsuite_sg.id}"
  description       = "Allow instance to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "scoutsuite_sg" {
  value = "${aws_security_group.scoutsuite_sg.id}"
}

#
# Terraformer
#

resource "aws_security_group" "terraformer_sg" {
  name   = "infosec_terraformer_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "allow_terraformer_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.terraformer_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "terraformer_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.terraformer_sg.id}"
  description       = "Allow instance to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "terraformer_sg" {
  value = "${aws_security_group.terraformer_sg.id}"
}

#
# VulnReport
#

resource "aws_security_group" "vulnreport_sg" {
  name   = "infosec_vulnreport_security_group"
  vpc_id = "${var.vpc_id}"

  tags {
    Environment = "${var.environment}"
  }
}

resource "aws_security_group_rule" "vulnreport_allow_ssh" {
  type              = "ingress"
  security_group_id = "${aws_security_group.vulnreport_sg.id}"
  description       = "Allow incoming SSH"

  from_port = "${var.ssh_port}"
  to_port   = "${var.ssh_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.jumpbox_ip}"]
}

resource "aws_security_group_rule" "vulnreport_allow_proxy" {
  type              = "ingress"
  security_group_id = "${aws_security_group.vulnreport_sg.id}"
  description       = "Allow incoming HTTPS"

  from_port = "${var.vulnreport_port}"
  to_port   = "${var.vulnreport_port}"
  protocol  = "${var.tcp_protocol}"

  cidr_blocks = ["${var.proxy_ip}"]
}

resource "aws_security_group_rule" "vulnreport_egress" {
  type              = "egress"
  security_group_id = "${aws_security_group.vulnreport_sg.id}"
  description       = "Allow instance to talk out"

  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

output "vulnreport_sg" {
  value = "${aws_security_group.vulnreport_sg.id}"
}
