resource "azurerm_virtual_machine" "centos_target" {
  name                  = "centos_target"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group}"
  network_interface_ids = ["${var.nic_id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "sftCentosDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"

    # The standard CentOS 7.3 image on Azure does not yet support cloud-init, so use 7-CI
    # https://docs.microsoft.com/en-us/azure/virtual-machines/linux/using-cloud-init?toc=%2Fazure%2Fvirtual-machines%2Flinux%2Ftoc.json
    sku = "7-CI"

    version = "latest"
  }

  os_profile {
    computer_name  = "centos-target"
    admin_username = "adminuser"
    custom_data    = "${data.template_file.sftd-centos-custom-data.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    # Azure will 400 Invalid Parameter if we do this entirely without keys
    # Azure will also 400 Invalid Parameter if the data provided for the key does not parse correctly
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = "${var.pubkey}}"
    }
  }

  tags {
    environment = "${var.environment}"
  }
}
