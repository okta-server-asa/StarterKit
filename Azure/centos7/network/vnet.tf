resource "azurerm_virtual_network" "vnet" {
  name                = "vnet"
  location            = "${var.location}"
  address_space       = "${var.address_space}"
  resource_group_name = "${var.resource_group}"

  tags {
    environment = "${var.environment}"
  }
}
