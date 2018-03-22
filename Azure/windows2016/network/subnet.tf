resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = "${var.resource_group}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"

  # TODO(rch): Figure out how best to configure this in Azure with tf
  address_prefix = "10.0.2.0/24"
}
