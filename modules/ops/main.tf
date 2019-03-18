variable "t2small_instance_type" {}
variable "t2medium_instance_type" {}
variable "t2large_instance_type" {}
variable "instance_ami" {}
variable "iam_instance_profile" {}
variable "key_name" {}
variable "volume_type" {}
variable "volume_size" {}
variable "mailserver_private_ip" {}
variable "mailserver_hostname" {}
variable "flashpaper_hostname" {}
variable "scoutsuite_hostname" {}
variable "vulnreport_hostname" {}
variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "flashpaper_sg" {}
variable "mailserver_sg" {}
variable "scoutsuite_sg" {}
variable "vsaq_sg" {}
variable "vulnreport_sg" {}

variable "security_groups" {
  type = "list"
}

#
# Flashpaper instance
#

data "template_file" "flashpaper_config" {
  template = "${file("secure/cloud-conf/flashpaper-cloud-conf.tpl")}"

  vars {
    hostname = "${var.flashpaper_hostname}"
  }
}

resource "aws_instance" "flashpaper_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2small_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.flashpaper_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.flashpaper_config.rendered}"

  tags = {
    Name  = "flashpaper-instance"
    Owner = "Information Security"
    Role  = "Web Application"
  }

  volume_tags {
    Name = "flashpaper-volume"
  }
}

#
# Mail server
#

data "template_file" "mailserver_config" {
  template = "${file("secure/cloud-conf/mailserver-cloud-conf.tpl")}"

  vars {
    hostname = "${var.mailserver_hostname}"
  }
}

resource "aws_instance" "mailserver_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2medium_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = true
  subnet_id                   = "${var.public_subnet_id}"
  vpc_security_group_ids      = ["${var.mailserver_sg}"]
  key_name                    = "${var.key_name}"
  private_ip                  = "${var.mailserver_private_ip}"

  user_data = "${data.template_file.mailserver_config.rendered}"

  tags = {
    Name  = "mailserver-instance"
    Owner = "Information Security"
    Role  = "Mail Server"
  }

  volume_tags = {
    Name = "mailserver-volume"
  }
}

resource "aws_eip" "mailserver_eip" {
  instance = "${aws_instance.mailserver_instance.id}"
  vpc      = true

  tags {
    Name = "mailserver-eip"
  }
}

output "mailserver_public_ip" {
  value = "${aws_instance.mailserver_instance.public_ip}"
}

#
# VSAQ instance
#

data "template_file" "vsaq_config" {
  template = "${file("secure/cloud-conf/vsaq-cloud-conf.tpl")}"

  vars {
    hostname = "vsaq.example.com"
  }
}

resource "aws_instance" "vsaq_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2small_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.vsaq_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.vsaq_config.rendered}"

  tags = {
    Name  = "vsaq-instance"
    Owner = "Information Security"
    Role  = "Web Application"
  }

  volume_tags = {
    Name = "vsaq-volume"
  }
}

#
# Scout Suite
#

data "template_file" "scoutsuite_config" {
  template = "${file("secure/cloud-conf/scoutsuite-cloud-conf.tpl")}"

  vars {
    hostname = "${var.scoutsuite_hostname}"
  }
}

resource "aws_instance" "scoutsuite_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2small_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.scoutsuite_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.scoutsuite_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  tags = {
    Name  = "scoutsuite-instance"
    Owner = "Information Security"
    Role  = "Scout Suite Instance"
  }

  volume_tags = {
    Name = "scoutsuite-volume"
  }
}

#
# VulnReport
#

data "template_file" "vulnreport_config" {
  template = "${file("secure/cloud-conf/vulnreport-cloud-conf.tpl")}"

  vars {
    hostname = "${var.vulnreport_hostname}"
  }
}

resource "aws_instance" "vulnreport_instance" {
  ami                         = "${var.raneto_instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.vulnreport_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.vulnreport_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  tags = {
    Name  = "vulnreport-instance"
    Owner = "Information Security"
    Role  = "VulnReport Instance"
  }

  volume_tags = {
    Name = "vulnreport-volume"
  }
}
