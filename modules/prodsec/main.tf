variable "burpent_sg" {}
variable "sonarqube_sg" {}
variable "dtrack_sg" {}
variable "anchore_sg" {}
variable "private_subnet_id" {}
variable "t2large_instance_type" {}
variable "burpent_instance_ami" {}
variable "sonarqube_instance_ami" {}
variable "dtrack_instance_ami" {}
variable "anchore_instance_ami" {}
variable "iam_instance_profile" {}
variable "key_name" {}
variable "volume_type" {}
variable "volume_size" {}

variable "security_groups" {
  type = "list"
}

#
# Burp Suite Enterprise
#

data "template_file" "burpent_config" {
  template = "${file("secure/cloud-conf/burpserver-cloud-conf.tpl")}"

  vars {
    hostname = "burp.example.com"
  }
}

resource "aws_instance" "burpent_instance" {
  ami                         = "${var.burpent_instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.burpent_sg}"]
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.burpent_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  tags = {
    Name  = "burpenterprise-instance"
    Owner = "Product Security"
    Role  = "Burp Enterprise Server"
  }

  volume_tags = {
    Name = "burpenterprise-volume"
  }
}

#
# SonarQube
#

data "template_file" "sonarqube_config" {
  template = "${file("secure/cloud-conf/sonarqube-cloud-conf.tpl")}"

  vars {
    hostname = "sq.example.com"
  }
}

resource "aws_instance" "sonarqube_instance" {
  ami                         = "${var.sonarqube_instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.sonarqube_sg}"]
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.sonarqube_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  tags = {
    Name  = "sonarqube-instance"
    Owner = "Product Security"
    Role  = "Sonar Qube Server"
  }

  volume_tags = {
    Name = "sonarqube-volume"
  }
}

#
# Dependency Track
#

data "template_file" "dtrack_config" {
  template = "${file("secure/cloud-conf/dtrack-cloud-conf.tpl")}"

  vars {
    hostname = "dt.example.com"
  }
}

resource "aws_instance" "dtrack_instance" {
  ami                         = "${var.dtrack_instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.dtrack_sg}"]
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.dtrack_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  tags = {
    Name  = "deptrack-instance"
    Owner = "Product Security"
    Role  = "Dependency Track Server"
  }

  volume_tags = {
    Name = "dtrack-volume"
  }
}

#
# Anchore
#

data "template_file" "anchore_config" {
  template = "${file("secure/cloud-conf/anchore-cloud-conf.tpl")}"

  vars {
    hostname = "anchore.example.com"
  }
}

resource "aws_instance" "anchore_instance" {
  ami                         = "${var.anchore_instance_ami}"
  instance_type               = "${var.t2large_instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  associate_public_ip_address = false
  subnet_id                   = "${var.private_subnet_id}"
  vpc_security_group_ids      = ["${var.anchore_sg}"]
  key_name                    = "${var.key_name}"
  user_data                   = "${data.template_file.anchore_config.rendered}"

  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = true
  }

  tags = {
    Name  = "anchore-instance"
    Owner = "Product Security"
    Role  = "Anchore Server"
  }

  volume_tags = {
    Name = "anchore-volume"
  }
}
