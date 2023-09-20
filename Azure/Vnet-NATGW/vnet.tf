# Resource group for vnet

resource "azurerm_resource_group" "nat" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

# # vnet

# resource "azurerm_virtual_network" "vnet" {
#   name                = var.vnet.name
#   location            = azurerm_resource_group.nat.location
#   resource_group_name = azurerm_resource_group.nat.name
#   address_space       = var.vnet.address_space

#   tags = {
#     owner       = var.vnet.tags.owner
#     environment = var.vnet.tags.environment
#   }
# }

# # Subnets creation and association

# resource "azurerm_subnet" "subnets" {
#   for_each = var.subnets

#   name                 = each.value.name
#   resource_group_name  = azurerm_resource_group.nat.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes     = each.value.address_space

#   depends_on = [
#     azurerm_virtual_network.vnet
#   ]
# }


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
  nat_gateways = keys(azurerm_nat_gateway.NATGWs)
  public_ips   = keys(azurerm_public_ip.pips)
  subnets      = keys(data.azurerm_subnet.existing_subnets)
}

# NAT Gateway and Public IP association

resource "azurerm_nat_gateway_public_ip_association" "NATGW-PIP" {

  for_each = var.nat_gateways

  nat_gateway_id       = [for nat_gateway in local.nat_gateways : azurerm_nat_gateway.NATGWs[nat_gateway].id if azurerm_nat_gateway.NATGWs[nat_gateway].name == each.value.name][0]
  public_ip_address_id = [for public_ip in local.public_ips : azurerm_public_ip.pips[public_ip].id if azurerm_public_ip.pips[public_ip].name == each.value.public_ip.name][0]
}

# locals {
#   nat_gateways = {for k,v in azurerm_nat_gateway.NATGWs : v.name => v.id }
#   public_ips   = keys(azurerm_public_ip.pips)
#   subnets      = keys(azurerm_subnet.subnets)
# }

# # NAT Gateway and Public IP association

# resource "azurerm_nat_gateway_public_ip_association" "NATGW-PIP" {

#   for_each = var.nat_gateways

#   nat_gateway_id       = [for k,v in local.nat_gateways : v if k == each.value.name][0]
#   public_ip_address_id = [for public_ip in local.public_ips : azurerm_public_ip.pips[public_ip].id if azurerm_public_ip.pips[public_ip].name == each.value.public_ip.name][0]
# }

# NAT Gateway and subnet association

resource "azurerm_subnet_nat_gateway_association" "NATGW-Subnet" {

  for_each = var.nat_gateways

  nat_gateway_id = [for nat_gateway in local.nat_gateways : azurerm_nat_gateway.NATGWs[nat_gateway].id if azurerm_nat_gateway.NATGWs[nat_gateway].name == each.value.name][0]
  subnet_id      = [for subnet in local.subnets : data.azurerm_subnet.existing_subnets[subnet].id if data.azurerm_subnet.existing_subnets[subnet].name == each.value.subnet_name][0]
}

data "azurerm_subnet" "existing_subnets" {
  for_each = var.existing_subnets

  name                 = each.value.name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}
