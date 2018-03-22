resource "azurerm_network_security_group" "publicipnsg" {
  name                = "securityGroup"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  security_rule {
    name                       = "ScaleFT"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "4421"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Can remove inbound RDP for a pure ScaleFT access demo
  security_rule {
    name                       = "RDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "${var.environment}"
  }
}
