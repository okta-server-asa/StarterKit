// Key name used to create the keypair used to encrypt the pw in the AWS console
resource "aws_key_pair" "sftwindeployer" {
  key_name   = "sftwindeployer-key"
  public_key = "${file("${var.aws_key_path}")}"
}
