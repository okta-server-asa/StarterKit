resource "aws_instance" "node" {
  count                  = 1
  ami                    = "${var.ami}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  source_dest_check      = false
  user_data              = "${var.userdata}"

  tags = {
    Name        = "${var.tagname}-${count.index}"
    Environment = "${var.environment}"
    terraform   = true
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }
}
