variable "misp_kms_key_name" {}

resource "aws_kms_key" "ebs_volume_encryption" {
  description             = "This key is used to encrypt EC2 volumes"
  deletion_window_in_days = 10
  enable_key_rotation     = true

  tags {
    Owner = "security@example.com"
  }
}

resource "aws_kms_alias" "ebs_volume_encryption" {
  name          = "${var.misp_kms_key_name}"
  target_key_id = "${aws_kms_key.ebs_volume_encryption.key_id}"
}
