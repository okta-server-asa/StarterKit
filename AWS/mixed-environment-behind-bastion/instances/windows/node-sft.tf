data "template_file" "win-userdata" {
  template = "<powershell>\n$ErrorActionPreference = \"Stop\"\n$ErrorView = \"CategoryView\"\n\n${var.userdata}\n</powershell>\n"
}

resource "aws_instance" "sft-windows" {
  count                  = "1"
  ami                    = "${var.ami}"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  source_dest_check      = false
  user_data              = "${data.template_file.win-userdata.rendered}"
  key_name               = "sftwindeployer-key"

  tags = {
    Name        = "win-${var.tagname}-${count.index}"
    Environment = "${var.environment}"
    terraform   = true
  }

  lifecycle {
    ignore_changes = ["user_data"]
  }
}
