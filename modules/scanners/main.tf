variable "nessus_sg" {}
variable "burpagent_sg" {}
variable "private_subnet_id" {}
variable "public_subnet_id" {}
variable "m4large_instance_type" {}
variable "nessus_instance_ami" {}
variable "burpagent_instance_ami" {}
variable "iam_instance_profile" {}
variable "burpagent_private_ip" {}
variable "key_name" {}
variable "volume_type" {}
variable "volume_size" {}

variable "security_groups" {
  type = "list"
}

#
# Nessus Scanner
#

data "template_file" "nessus_config" {
  template = "${file("secure/cloud-conf/nessus-cloud-conf.tpl")}"

  vars {
    hostname = "nessus.example.com"
  }
}

resource "aws_instance" "nessus_scanner" {
  ami                         = "${var.nessus_instance_ami}"
  instance_type               = "${var.m4large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = true
  subnet_id                   = "${var.public_subnet_id}"
  vpc_security_group_ids      = ["${var.nessus_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.nessus_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  tags = {
    Name  = "nessus-instance"
    Owner = "Information Security"
    Role  = "Nessus Scanner"
  }

  volume_tags = {
    Name = "nessus-volume"
  }
}

resource "aws_eip" "nessus-eip" {
  instance = "${aws_instance.nessus_scanner.id}"
  vpc      = true

  tags {
    Name = "nessus-eip"
  }
}

output "nessus_public_ip" {
  value = "${aws_instance.nessus_scanner.public_ip}"
}

#
# Burp Scanner
#

data "template_file" "burpagent_config" {
  template = "${file("secure/cloud-conf/burpagent-cloud-conf.tpl")}"

  vars {
    hostname = "ba01.example.com"
  }
}

resource "aws_instance" "burpagent_instance" {
  ami                         = "${var.burpagent_instance_ami}"
  instance_type               = "${var.m4large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.burpagent_sg}"]
  key_name                    = "${var.key_name}"
  private_ip                  = "${var.burpagent_private_ip}"

  user_data = "${data.template_file.burpagent_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  tags = {
    Name  = "ba1-instance"
    Owner = "Product Security"
    Role  = "Burp Enterprise Agent"
  }

  volume_tags = {
    Name = "ba1-volume"
  }
}
