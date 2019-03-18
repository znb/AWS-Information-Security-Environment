variable "public_subnet_id" {}
variable "private_subnet_id" {}
variable "t2small_instance_type" {}
variable "t2medium_instance_type" {}
variable "instance_ami" {}
variable "terraform_instance_ami" {}
variable "iam_instance_profile" {}
variable "key_name" {}
variable "jumpbox_private_ip" {}
variable "jumpbox_hostname" {}
variable "terraform_hostname" {}
variable "jumpbox_sg" {}
variable "terraformer_sg" {}
variable "volume_type" {}
variable "volume_size" {}

variable "security_groups" {
  type = "list"
}

#
# Jumpbox
#

data "template_file" "jumpbox_config" {
  template = "${file("secure/cloud-conf/jumpbox-cloud-conf.tpl")}"

  vars {
    hostname        = "${var.jumpbox_hostname}"
    host_private_ip = "${var.jumpbox_private_ip}"
  }
}

resource "aws_instance" "jumpbox_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2small_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = true
  subnet_id                   = "${var.public_subnet_id}"
  vpc_security_group_ids      = ["${var.jumpbox_sg}"]
  key_name                    = "${var.key_name}"
  private_ip                  = "${var.jumpbox_private_ip}"

  user_data = "${data.template_file.jumpbox_config.rendered}"

  tags = {
    Name  = "jumpbox-instance"
    Owner = "Information Security"
    Role  = "Security Operations"
  }

  volume_tags {
    Name = "jumpbox-volume"
  }
}

resource "aws_eip" "jumpbox_eip" {
  instance = "${aws_instance.jumpbox_instance.id}"
  vpc      = true

  tags {
    Name = "jumpbox-eip"
  }
}

output "jumpbox_public_ip" {
  value = "${aws_instance.jumpbox_instance.public_ip}"
}

#
# Terraformer
#

data "template_file" "terraformer_config" {
  template = "${file("secure/cloud-conf/terraformer-cloud-conf.tpl")}"

  vars {
    hostname = "${var.terraform_hostname}"
  }
}

resource "aws_instance" "terraformer_instance" {
  ami                         = "${var.terraform_instance_ami}"
  instance_type               = "${var.t2medium_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  ebs_optimized               = false
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.terraformer_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.terraformer_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  tags = {
    Name  = "terraformer-instance"
    Owner = "Information Security"
    Role  = "Terraformer Server"
  }

  volume_tags = {
    Name = "terraformer-volume"
  }
}
