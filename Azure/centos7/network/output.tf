output "nic_id" {
  value = "${azurerm_network_interface.vnic.id}"
}

output "public_ip" {
  value = "${azurerm_public_ip.publicip.ip_address}"
}
