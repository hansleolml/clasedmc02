resource "azurerm_resource_group" "rg_01" {
  name     = var.rg_01_name
  location = var.location
}

resource "azurerm_resource_group" "rg_02" {
  name     = var.rg_02_name
  location = var.location
}
