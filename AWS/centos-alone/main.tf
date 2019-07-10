module "net" {
  source             = "./network"
  name               = var.name
  environment        = var.environment
  availability_zones = ["us-west-2a", "us-west-2b"]
  public_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
}

module "instances" {
  source           = "./instances"
  vpc_id           = module.net.vpc_id
  name             = var.name
  environment      = var.environment
  subnet           = module.net.public_subnet_ids[0]
  sftd_version     = var.sftd_version
  enrollment_token = var.enrollment_token
}

