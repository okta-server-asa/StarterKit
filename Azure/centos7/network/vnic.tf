resource "azurerm_network_interface" "vnic" {
  name                = "vnic"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "nicConfig"
    private_ip_address_allocation = "dynamic"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    public_ip_address_id          = "${azurerm_public_ip.publicip.id}"
  }

  tags {
    environment = "${var.environment}"
  }
}
