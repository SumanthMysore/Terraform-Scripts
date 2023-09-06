output "nat_gateways" {
  value = azurerm_nat_gateway.NATGWs
}

output "pips" {
  value = azurerm_public_ip.pips
}

output "subnets" {
  value = azurerm_subnet.subnets
}
