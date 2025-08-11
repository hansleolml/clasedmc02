resource "azurerm_network_security_group" "nsg_01" {
  name                = "nsg-dmcexam-dev-eastus2-001"
  location            = azurerm_resource_group.rg_01.location
  resource_group_name = azurerm_resource_group.rg_01.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_nic" {
  network_interface_id      = azurerm_network_interface.nic_01.id
  network_security_group_id = azurerm_network_security_group.nsg_01.id
}