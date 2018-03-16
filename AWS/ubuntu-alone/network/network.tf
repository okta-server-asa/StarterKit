module "vpc_main" {
  source      = "./vpc"
  name        = "${var.name}"
  environment = "${var.environment}"
}

data "aws_vpc" "main" {
  id = "${module.vpc_main.vpc_id}"
}

module "public_subnet" {
  source              = "./public_subnet"
  name                = "${var.name}-pub"
  vpc_id              = "${module.vpc_main.vpc_id}"
  cidrs               = "${var.public_cidrs}"
  availability_zones  = "${var.availability_zones}"
  environment         = "${var.environment}"
  internet_gateway_id = "${module.vpc_main.internet_gateway_id}"
}
