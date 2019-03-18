variable "t2large_instance_type" {}
variable "instance_ami" {}
variable "iam_instance_profile" {}
variable "key_name" {}
variable "volume_type" {}
variable "volume_size" {}
variable "grr_sg" {}
variable "misp_sg" {}
variable "hive_sg" {}
variable "hive_private_ip" {}
variable "cortex_private_ip" {}
variable "private_subnet_id" {}

variable "security_groups" {
  type = "list"
}

#
# GRR
#

data "template_file" "grr_config" {
  template = "${file("secure/cloud-conf/grr-cloud-conf.tpl")}"

  vars {
    hostname = "grr.example.com"
  }
}

resource "aws_instance" "grr_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  ebs_optimized               = false
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.grr_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.grr_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  volume_tags {
    Name = "grr-volume"
  }

  tags = {
    Name  = "grr-instance"
    Owner = "Incident Response"
    Role  = "GRR Server"
  }
}

#
# MISP
#

data "template_file" "misp_config" {
  template = "${file("secure/cloud-conf/misp-cloud-conf.tpl")}"

  vars {
    hostname = "misp.example.com"
  }
}

resource "aws_instance" "misp_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  ebs_optimized               = false
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.misp_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.misp_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  volume_tags {
    Name = "misp-volume"
  }

  tags = {
    Name  = "misp-instance"
    Owner = "Incident Response"
    Role  = "MISP Server"
  }
}

output "misp_instance_id" {
  value = "${aws_instance.misp_instance.id}"
}

#
# Hive
#

data "template_file" "hive_config" {
  template = "${file("secure/cloud-conf/hive-cloud-conf.tpl")}"

  vars {
    hostname = "hive.example.com"
  }
}

resource "aws_instance" "hive_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  ebs_optimized               = false
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.hive_sg}"]
  key_name                    = "${var.key_name}"
  private_ip                  = "${var.hive_private_ip}"

  user_data = "${data.template_file.hive_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  volume_tags {
    Name = "hive-volume"
  }

  tags = {
    Name  = "hive-instance"
    Owner = "Incident Response"
    Role  = "Hive Server"
  }
}

#
# Cortex
#

data "template_file" "cortex_config" {
  template = "${file("secure/cloud-conf/cortex-cloud-conf.tpl")}"

  vars {
    hostname          = "cortex.example.com"
    cortex_private_ip = "${var.cortex_private_ip}"
  }
}

resource "aws_instance" "cortex_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  ebs_optimized               = false
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.hive_sg}"]
  key_name                    = "${var.key_name}"
  private_ip                  = "${var.cortex_private_ip}"

  user_data = "${data.template_file.cortex_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  volume_tags {
    Name = "cortex-volume"
  }

  tags = {
    Name  = "cortex-instance"
    Owner = "Incident Response"
    Role  = "Cortex Server"
  }
}
