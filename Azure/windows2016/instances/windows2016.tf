resource "azurerm_virtual_machine" "windows_target" {
  name                  = "windows_target"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group}"
  network_interface_ids = ["${var.nic_id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "sftWinDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"

    version = "latest"
  }

  os_profile {
    computer_name  = "windows-target"
    admin_username = "adminuser"
    admin_password = "${var.admin_password}"
    custom_data    = "${data.template_file.sftd-windows-custom-data.rendered}"
  }

  os_profile_windows_config {
    # In the Azure API, this value defaults to true, but Terraform will default it to false
    # https://github.com/hashicorp/terraform/issues/9995
    provision_vm_agent = "true"
  }

  tags {
    environment = "${var.environment}"
  }
}

resource "azurerm_virtual_machine_extension" "install_sftd" {
  name                 = "install_sftd"
  location             = "${var.location}"
  resource_group_name  = "${var.resource_group}"
  virtual_machine_name = "${azurerm_virtual_machine.windows_target.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.8"

  settings = <<RUNCUSTOMDATA
    {
        "commandToExecute": "copy /y C:\\AzureData\\CustomData.bin C:\\AzureData\\CustomData.ps1 && powershell.exe -ExecutionPolicy unrestricted -NoProfile -NonInteractive -File C:\\AzureData\\CustomData.ps1 && exit 0"
    }
RUNCUSTOMDATA

  tags {
    environment = "${var.environment}"
  }
}
