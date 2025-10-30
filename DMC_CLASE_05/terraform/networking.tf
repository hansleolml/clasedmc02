#Este archivo contiene las virtual networks, subnets y los Network Interface Card

resource "azurerm_virtual_network" "vn_01" {
  name                = "vnet-dmcexam-dev-eastus2-001"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_01.location
  resource_group_name = azurerm_resource_group.rg_01.name
}

resource "azurerm_subnet" "vn_01_sn_01" {
  name                 = "snet-dmcexam-dev-eastus2-001"
  resource_group_name  = azurerm_resource_group.rg_01.name
  virtual_network_name = azurerm_virtual_network.vn_01.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_network_interface" "nic_01" {
  name                = "nic-dmcexam-dev-eastus2-001"
  location            = azurerm_resource_group.rg_01.location
  resource_group_name = azurerm_resource_group.rg_01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vn_01_sn_01.id
    private_ip_address_allocation = "Dynamic"
  }
}
