data "aws_ami" "centos7" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["410186602215"]
}

module "centos7" {
  source      = "./linux"
  tagname     = "centos7-testing"
  ami         = "${data.aws_ami.centos7.id}"
  environment = "${var.environment}"
  userdata    = "${data.template_file.sftd-centos-userdata.rendered}"
  vpc_id      = "${var.vpc_id}"
}
