resource "azurerm_public_ip" "publicip" {
  name                         = "publicIP"
  location                     = "${var.location}"
  resource_group_name          = "${var.resource_group}"
  public_ip_address_allocation = "static"
  idle_timeout_in_minutes      = 30

  tags {
    environment = "${var.environment}"
  }
}
