provider "aws" {
  shared_credentials_file = "secure/terraform"
  region                  = "${var.aws_region}"
  profile                 = "${var.profile}"
}

module "network" {
  source                   = "./modules/network"
  vpc_cidr                 = "${var.vpc_cidr}"
  internet_cidr            = "${var.internet_cidr}"
  public_cidr              = "${var.public_cidr}"
  private_cidr             = "${var.private_cidr}"
  backup_private_cidr      = "${var.backup_private_cidr}"
  availability_zone        = "${var.availability_zone}"
  backup_availability_zone = "${var.backup_availability_zone}"
}

module "security-groups" {
  source          = "./modules/security-groups"
  environment     = "${var.environment}"
  vpc_id          = "${module.network.vpc_id}"
  vpc_cidr        = "${var.vpc_cidr}"
  public_cidr     = "${var.public_cidr}"
  tcp_protocol    = "${var.tcp_protocol}"
  ssh_port        = "${var.ssh_port}"
  smtp_port       = "${var.smtp_port}"
  http_port       = "${var.http_port}"
  https_port      = "${var.https_port}"
  nessus_port     = "${var.nessus_port}"
  postgres_port   = "${var.postgres_port}"
  mysql_port      = "${var.mysql_port}"
  grr_client_port = "${var.grr_client_port}"
  grr_admin_port  = "${var.grr_admin_port}"
  burp_db_port    = "${var.burp_db_port}"
  burp_api_port   = "${var.burp_api_port}"
  vsaq_port       = "${var.vsaq_port}"
  sonarqube_port  = "${var.sonarqube_port}"
  dtrack_port     = "${var.dtrack_port}"
  anchore_port    = "${var.anchore_port}"
  hive_port       = "${var.hive_port}"
  cortex_port     = "${var.cortex_port}"
  scoutsuite_port = "${var.scoutsuite_port}"
  flashpaper_port = "${var.flashpaper_port}"
  vulnreport_port = "${var.vulnreport_port}"
  office_ip       = "${var.office_ip}"
  jumpbox_ip      = "${var.jumpbox_ip}"
  proxy_ip        = "${var.proxy_ip}"
  the_world       = "${var.the_world}"
}

module "management" {
  source                 = "./modules/management"
  public_subnet_id       = "${module.network.public_subnet_id}"
  private_subnet_id      = "${module.network.private_subnet_id}"
  jumpbox_private_ip     = "${var.jumpbox_private_ip}"
  jumpbox_hostname       = "${var.jumpbox_hostname}"
  terraform_hostname     = "${var.terraform_hostname}"
  key_name               = "${var.key_name}"
  t2small_instance_type  = "${var.t2small_instance_type}"
  t2medium_instance_type = "${var.t2medium_instance_type}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  instance_ami           = "${var.instance_ami}"
  terraform_instance_ami = "${var.terraform_instance_ami}"
  volume_size            = "${var.volume_size}"
  volume_type            = "${var.volume_type}"

  security_groups = [
    "${module.security-groups.jumpbox_sg}",
    "${module.security-groups.terraformer_sg}",
  ]

  jumpbox_sg     = "${module.security-groups.jumpbox_sg}"
  terraformer_sg = "${module.security-groups.terraformer_sg}"
}

module "rds" {
  source                     = "./modules/rds"
  db_subnet_group_name       = "${module.network.db_subnet_group}"
  allocated_storage          = "${var.allocated_storage}"
  misp_allocated_storage     = "${var.misp_allocated_storage}"
  storage_type               = "${var.storage_type}"
  engine                     = "${var.engine}"
  mysql_engine               = "${var.mysql_engine}"
  engine_version             = "${var.engine_version}"
  mysql_engine_version       = "${var.mysql_engine_version}"
  instance_class             = "${var.instance_class}"
  misp_instance_class        = "${var.misp_instance_class}"
  auto_minor_version_upgrade = "${var.auto_minor_version_upgrade}"
  publicly_accessible        = "${var.publicly_accessible}"
  storage_encrypted          = "${var.storage_encrypted}"
  backup_retention_period    = "${var.backup_retention_period}"
  security_groups            = ["${module.security-groups.rds_sg}"]
  rds_sg                     = "${module.security-groups.rds_sg}"

  # DFIR GRR
  grr_identifier = "${var.grr_identifier}"
  grr_name       = "${var.grr_name}"
  grr_username   = "${var.grr_username}"
  grr_password   = "${var.grr_password}"

  # Burp Enterprise
  burpent_identifier = "${var.burpent_identifier}"
  burpent_name       = "${var.burpent_name}"
  burpent_username   = "${var.burpent_username}"
  burpent_password   = "${var.burpent_password}"

  # Sonarqube
  sonarqube_identifier = "${var.sonarqube_identifier}"
  sonarqube_name       = "${var.sonarqube_name}"
  sonarqube_username   = "${var.sonarqube_username}"
  sonarqube_password   = "${var.sonarqube_password}"

  # Dependency Track
  dtrack_identifier = "${var.dtrack_identifier}"
  dtrack_name       = "${var.dtrack_name}"
  dtrack_username   = "${var.dtrack_username}"
  dtrack_password   = "${var.dtrack_password}"

  # MISP
  misp_identifier = "${var.misp_identifier}"
  misp_name       = "${var.misp_name}"
  misp_username   = "${var.misp_username}"
  misp_password   = "${var.misp_password}"

  # VulnReport
  vulnreport_identifier = "${var.vulnreport_identifier}"
  vulnreport_name       = "${var.vulnreport_name}"
  vulnreport_username   = "${var.vulnreport_username}"
  vulnreport_password   = "${var.misp_password}"
}

module "kms" {
  source            = "./modules/kms"
  misp_kms_key_name = "${var.misp_kms_key_name}"
}

module "ebs" {
  depends_on       = ["${module.dfir.misp_instance_id}"]
  source           = "./modules/ebs"
  misp_volume_az   = "${var.misp_volume_az}"
  misp_instance_id = "${module.dfir.misp_instance_id}"
  misp_volume_size = "${var.misp_volume_size}"
  misp_volume_type = "${var.misp_volume_type}"
  misp_volume_name = "${var.misp_volume_name}"
  misp_device_name = "${var.misp_device_name}"
}

module "proxy" {
  source                = "./modules/proxy"
  public_subnet_id      = "${module.network.public_subnet_id}"
  key_name              = "${var.key_name}"
  t2large_instance_type = "${var.t2large_instance_type}"
  iam_instance_profile  = "${var.iam_instance_profile}"
  volume_size           = "${var.volume_size}"
  volume_type           = "${var.volume_type}"
  instance_ami          = "${var.instance_ami}"
  security_groups       = ["${module.security-groups.proxy_sg}"]
  proxy_sg              = "${module.security-groups.proxy_sg}"
}

module "ops" {
  source                 = "./modules/ops"
  public_subnet_id       = "${module.network.public_subnet_id}"
  private_subnet_id      = "${module.network.private_subnet_id}"
  key_name               = "${var.key_name}"
  mailserver_private_ip  = "${var.mailserver_private_ip}"
  mailserver_hostname    = "${var.mailserver_hostname}"
  flashpaper_hostname    = "${var.flashpaper_hostname}"
  scoutsuite_hostname    = "${var.scoutsuite_hostname}"
  raneto_hostname        = "${var.raneto_hostname}"
  vulnreport_hostname    = "${var.vulnreport_hostname}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  t2small_instance_type  = "${var.t2small_instance_type}"
  t2medium_instance_type = "${var.t2medium_instance_type}"
  t2large_instance_type  = "${var.t2large_instance_type}"
  instance_ami           = "${var.instance_ami}"
  raneto_instance_ami    = "${var.raneto_instance_ami}"
  volume_type            = "${var.volume_type}"
  volume_size            = "${var.volume_size}"

  security_groups = [
    "${module.security-groups.flashpaper_sg}",
    "${module.security-groups.mailserver_sg}",
    "${module.security-groups.vsaq_sg}",
    "${module.security-groups.scoutsuite_sg}",
    "${module.security-groups.vulnreport_sg}",
  ]

  flashpaper_sg = "${module.security-groups.flashpaper_sg}"
  mailserver_sg = "${module.security-groups.mailserver_sg}"
  vsaq_sg       = "${module.security-groups.vsaq_sg}"
  scoutsuite_sg = "${module.security-groups.scoutsuite_sg}"
  vulnreport_sg = "${module.security-groups.vulnreport_sg}"
}

module "prodsec" {
  source                 = "./modules/prodsec"
  private_subnet_id      = "${module.network.private_subnet_id}"
  t2large_instance_type  = "${var.t2large_instance_type}"
  burpent_instance_ami   = "${var.burpent_instance_ami}"
  sonarqube_instance_ami = "${var.sonarqube_instance_ami}"
  dtrack_instance_ami    = "${var.dtrack_instance_ami}"
  anchore_instance_ami   = "${var.anchore_instance_ami}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  key_name               = "${var.key_name}"
  volume_type            = "${var.volume_type}"
  volume_size            = "${var.volume_size}"

  security_groups = [
    "${module.security-groups.burpent_sg}",
    "${module.security-groups.sonarqube_sg}",
    "${module.security-groups.dtrack_sg}",
    "${module.security-groups.anchore_sg}",
  ]

  burpent_sg   = "${module.security-groups.burpent_sg}"
  sonarqube_sg = "${module.security-groups.sonarqube_sg}"
  dtrack_sg    = "${module.security-groups.dtrack_sg}"
  anchore_sg   = "${module.security-groups.anchore_sg}"
}

module "scanners" {
  source                 = "./modules/scanners"
  public_subnet_id       = "${module.network.public_subnet_id}"
  private_subnet_id      = "${module.network.private_subnet_id}"
  m4large_instance_type  = "${var.m4large_instance_type}"
  nessus_instance_ami    = "${var.nessus_instance_ami}"
  burpagent_instance_ami = "${var.burpagent_instance_ami}"
  iam_instance_profile   = "${var.iam_instance_profile}"
  burpagent_private_ip   = "${var.burpagent_private_ip}"
  key_name               = "${var.key_name}"
  volume_type            = "${var.volume_type}"
  volume_size            = "${var.volume_size}"

  security_groups = [
    "${module.security-groups.nessus_sg}",
    "${module.security-groups.burpagent_sg}",
  ]

  nessus_sg    = "${module.security-groups.nessus_sg}"
  burpagent_sg = "${module.security-groups.burpagent_sg}"
}

module "dfir" {
  source                = "./modules/dfir"
  private_subnet_id     = "${module.network.private_subnet_id}"
  t2large_instance_type = "${var.t2large_instance_type}"
  iam_instance_profile  = "${var.iam_instance_profile}"
  instance_ami          = "${var.instance_ami}"
  key_name              = "${var.key_name}"
  hive_private_ip       = "${var.hive_private_ip}"
  cortex_private_ip     = "${var.cortex_private_ip}"
  volume_type           = "${var.volume_type}"
  volume_size           = "${var.volume_size}"

  security_groups = [
    "${module.security-groups.grr_sg}",
    "${module.security-groups.misp_sg}",
    "${module.security-groups.hive_sg}",
  ]

  grr_sg  = "${module.security-groups.grr_sg}"
  misp_sg = "${module.security-groups.misp_sg}"
  hive_sg = "${module.security-groups.hive_sg}"
}
