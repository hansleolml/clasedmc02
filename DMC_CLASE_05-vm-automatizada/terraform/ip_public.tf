resource "azurerm_public_ip" "ip_01" {
  name                = "ip-quirozdmc-dev-westeurope-001"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg_01.name
  allocation_method   = "Static"
}