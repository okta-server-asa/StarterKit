provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "rsrcgroup" {
  name     = "sftResourceGroup"
  location = "${var.location}"

  tags {
    environment = "${var.environment}"
  }
}

module "net" {
  source         = "./network"
  name           = "${var.name}"
  environment    = "${var.environment}"
  location       = "${var.location}"
  resource_group = "${azurerm_resource_group.rsrcgroup.name}"
  address_space  = ["10.0.0.0/16"]
}

module "instances" {
  source           = "./instances"
  name             = "${var.name}"
  environment      = "${var.environment}"
  location         = "${var.location}"
  resource_group   = "${azurerm_resource_group.rsrcgroup.name}"
  sftd_version     = "${var.sftd_version}"
  enrollment_token = "${var.enrollment_token}"
  nic_id           = "${module.net.nic_id}"
  public_ip        = "${module.net.public_ip}"
  admin_password   = "${var.admin_password}"
}
