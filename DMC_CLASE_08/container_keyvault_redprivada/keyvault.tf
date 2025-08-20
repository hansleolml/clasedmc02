# Obtener datos del usuario actual autenticado en Azure CLI
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv_01" {
  name                          = var.kv_01_name
  location                      = azurerm_resource_group.rg_01.location
  resource_group_name           = azurerm_resource_group.rg_01.name
  enabled_for_disk_encryption   = true
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  public_network_access_enabled = true
  enable_rbac_authorization     = true
  sku_name                      = "standard"
  tags                          = var.tags

}

# Private Endpoint para el Key Vault
resource "azurerm_private_endpoint" "kv_pep_aca_01" {
  name                          = var.kv_pep_aca_01_name
  location                      = azurerm_resource_group.rg_01.location
  resource_group_name           = azurerm_resource_group.rg_01.name
  subnet_id                     = azurerm_subnet.vnet_01_subnet_02.id
  custom_network_interface_name = var.kv_pep_aca_01_name_nic

  private_service_connection {
    name                           = "kv-private-connection-001"
    private_connection_resource_id = azurerm_key_vault.kv_01.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.dnspr_01.id]
  }
}



