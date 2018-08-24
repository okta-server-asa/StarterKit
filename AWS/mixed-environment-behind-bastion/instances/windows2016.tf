// Latest AMI
data "aws_ami" "windows2016" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"] # Microsoft
}

module "windows2016" {
  source      = "./windows"
  tagname     = "windows2016-sft"
  environment = "${var.environment}"
  ami         = "${data.aws_ami.windows2016.id}"
  userdata    = "${data.template_file.sftd-windows-userdata.rendered}"
  vpc_id      = "${var.vpc_id}"
}
