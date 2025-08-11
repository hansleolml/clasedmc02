resource "azurerm_linux_virtual_machine" "vm_01" {
  name                = "vm-dmcexam-dev-eastus2-001"
  resource_group_name = azurerm_resource_group.rg_01.name
  location            = azurerm_resource_group.rg_01.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  custom_data         = base64encode(file("install.sh"))

  network_interface_ids = [
    azurerm_network_interface.nic_01.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("id_rsa_dmc_02.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

#ssh-keygen -t rsa -b 4096 -f id_rsa_dmc_02