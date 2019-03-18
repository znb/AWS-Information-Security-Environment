variable "public_subnet_id" {}
variable "t2large_instance_type" {}
variable "instance_ami" {}
variable "iam_instance_profile" {}
variable "key_name" {}
variable "volume_size" {}
variable "volume_type" {}
variable "proxy_sg" {}

variable "security_groups" {
  type = "list"
}

data "template_file" "proxy_config" {
  template = "${file("secure/cloud-conf/proxy-cloud-conf.tpl")}"

  vars {
    hostname = "proxy.example.com"
  }
}

resource "aws_instance" "proxy_instance" {
  ami                         = "${var.instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = true
  subnet_id                   = "${var.public_subnet_id}"
  vpc_security_group_ids      = ["${var.proxy_sg}"]
  key_name                    = "${var.key_name}"

  user_data = "${data.template_file.proxy_config.rendered}"

  tags = {
    Name  = "proxy-instance"
    Owner = "Information Security"
    Role  = "Proxy Server"
  }

  volume_tags = {
    Name = "proxy-volume"
  }
}

resource "aws_eip" "proxy_eip" {
  instance = "${aws_instance.proxy_instance.id}"
  vpc      = true

  tags {
    Name = "proxy-eip"
  }
}

output "proxy_public_ip" {
  value = "${aws_instance.proxy_instance.public_ip}"
}
