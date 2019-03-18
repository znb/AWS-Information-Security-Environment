variable "misp_volume_az" {}
variable "misp_volume_size" {}
variable "misp_instance_id" {}
variable "misp_volume_type" {}
variable "misp_volume_name" {}
variable "misp_device_name" {}

variable "depends_on" {
  type = "list"
}

resource "null_resource" "dependencies" {
  provisioner "local-exec" {
    command = "echo '${join("\",\"", var.depends_on)}'"
  }
}

resource "aws_ebs_volume" "misp_volume" {
  size              = "${var.misp_volume_size}"
  type              = "${var.misp_volume_type}"
  encrypted         = true
  availability_zone = "${var.misp_volume_az}"

  tags {
    Name = "${var.misp_volume_name}-volume"
  }
}

resource "aws_volume_attachment" "misp_volume_attach" {
  depends_on  = ["aws_ebs_volume.misp_volume"]
  device_name = "${var.misp_device_name}"
  volume_id   = "${aws_ebs_volume.misp_volume.id}"
  instance_id = "${var.misp_instance_id}"
}
