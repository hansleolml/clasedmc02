resource "azurerm_mssql_server" "sql_01" {
  name                          = var.sql_01_server_name
  resource_group_name           = azurerm_resource_group.rg_01.name
  location                      = var.sql_01_location
  version                       = "12.0"
  administrator_login           = var.sql_01_admin_login
  administrator_login_password  = var.sql_01_admin_password
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
  tags                          = var.tags
}

resource "azurerm_mssql_database" "sql_01_db" {
  name        = var.sql_01_db_name
  server_id   = azurerm_mssql_server.sql_01.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  sku_name    = "Basic"
  max_size_gb = 2
  tags        = var.tags
}
