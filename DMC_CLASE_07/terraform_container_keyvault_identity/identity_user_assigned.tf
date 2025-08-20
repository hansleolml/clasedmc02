
#IDENTITY USER - ASIGNED : PERMISOS KEYVAULT Y CONTAINER REGISTRY
resource "azurerm_user_assigned_identity" "identity_01" {
  resource_group_name = azurerm_resource_group.rg_01.name
  location            = azurerm_resource_group.rg_01.location
  name                = "id-ca-dmc-dev-eastus2-001"
  tags                = var.tags
}