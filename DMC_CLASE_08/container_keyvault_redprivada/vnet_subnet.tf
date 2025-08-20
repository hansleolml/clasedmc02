resource "azurerm_virtual_network" "vnet_01" {
  name                = var.vnet_01_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_01.name
  address_space       = var.vnet_01_ip
  tags                = var.tags
}

resource "azurerm_subnet" "vnet_01_subnet_01" {
  name                 = var.vnet_01_subnet_01_name
  resource_group_name  = azurerm_resource_group.rg_01.name
  virtual_network_name = azurerm_virtual_network.vnet_01.name
  address_prefixes     = var.vnet_01_subnet_01_ip
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "vnet_01_subnet_02" {
  name                 = var.vnet_01_subnet_02_name
  resource_group_name  = azurerm_resource_group.rg_01.name
  virtual_network_name = azurerm_virtual_network.vnet_01.name
  address_prefixes     = var.vnet_01_subnet_02_ip
}
