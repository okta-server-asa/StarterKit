// Latest Ubuntu AMI
data "aws_ami" "ubuntu1604" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

// Ubuntu node
module "ubuntu1604" {
  source      = "./linux"
  tagname     = "ubuntu-target"
  ami         = "${data.aws_ami.ubuntu1604.id}"
  environment = "${var.environment}"
  userdata    = "${data.template_file.sftd-ubuntu-userdata.rendered}"
  vpc_id      = "${var.vpc_id}"
}

// Ubuntu node
module "ubuntu1604-bastion" {
  source      = "./linux"
  tagname     = "ubuntu-bastion"
  ami         = "${data.aws_ami.ubuntu1604.id}"
  environment = "${var.environment}"
  userdata    = "${data.template_file.sftd-ubuntu-bastion-userdata.rendered}"
  vpc_id      = "${var.vpc_id}"
}
