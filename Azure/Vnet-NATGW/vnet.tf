# Resource group for vnet

resource "azurerm_resource_group" "nat" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

# NAT Gateway

resource "azurerm_nat_gateway" "NATGWs" {

  for_each = var.nat_gateways

  name                    = each.value.name
  location                = azurerm_resource_group.nat.location
  resource_group_name     = azurerm_resource_group.nat.name
  idle_timeout_in_minutes = each.value.idle_timeout_in_minutes
}

# Public IP for NAT Gateway

resource "azurerm_public_ip" "pips" {

  for_each = var.nat_gateways

  name                = each.value.public_ip.name
  location            = azurerm_resource_group.nat.location
  resource_group_name = azurerm_resource_group.nat.name
  allocation_method   = each.value.public_ip.allocation_method
  sku                 = each.value.public_ip.sku
}

locals {
  nat_gateways = values(azurerm_nat_gateway.NATGWs)
  public_ips   = values(azurerm_public_ip.pips)
}

# NAT Gateway and Public IP association

resource "azurerm_nat_gateway_public_ip_association" "NATGW-PIP" {

  for_each = var.nat_gateways

  nat_gateway_id       = [for nat_gateway in local.nat_gateways : nat_gateway.id if nat_gateway.name == each.value.name][0]
  public_ip_address_id = [for public_ip in local.public_ips : public_ip.id if public_ip.name == each.value.public_ip.name][0]
}

# NAT Gateway and subnet association

data "azurerm_subnet" "subnets" {
  for_each = var.nat_gateway_subnet_associations

  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

locals {
  subnets = values(data.azurerm_subnet.subnets)
}

resource "azurerm_subnet_nat_gateway_association" "NATGW-Subnet" {

  for_each = var.nat_gateways

  nat_gateway_id = [for nat_gateway in local.nat_gateways : nat_gateway.id if nat_gateway.name == each.value.name][0]
  subnet_id      = [for subnet in local.subnets : subnet.id if subnet.name == each.value.subnet_name][0]
}
