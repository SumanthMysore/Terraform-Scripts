output "subnets" {
  value = azurerm_subnet.subnets
}

output "fw_pips" {
  value = azurerm_public_ip.fw_pips
}

output "fw_management_pips" {
  value = azurerm_public_ip.fw_management_pips
}

output "basic_sku_fw_policies" {
  value = azurerm_firewall_policy.basic_sku_fw_policies
}