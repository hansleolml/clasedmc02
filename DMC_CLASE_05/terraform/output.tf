output "public_ip_address" {
  value = azurerm_public_ip.ip_01.ip_address
}
#terraform output -raw public_ip_address
