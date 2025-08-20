resource "azurerm_public_ip" "ip_01" {
  name                = "ip-dmcexam-dev-eastus2-001"
  location            = "East US 2"
  resource_group_name = azurerm_resource_group.rg_01.name
  allocation_method   = "Static"
}