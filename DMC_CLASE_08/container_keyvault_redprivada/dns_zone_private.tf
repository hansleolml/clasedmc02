resource "azurerm_private_dns_zone" "dnspr_01" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.rg_01.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnspr_link_01" {
  name                  = "dns-vnet-link"
  resource_group_name   = azurerm_resource_group.rg_01.name
  private_dns_zone_name = azurerm_private_dns_zone.dnspr_01.name
  virtual_network_id    = azurerm_virtual_network.vnet_01.id
}