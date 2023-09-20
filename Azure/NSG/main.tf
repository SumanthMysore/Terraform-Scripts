# RG for NSG

resource "azurerm_resource_group" "nsg-rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

# vnet

resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets

  name                = each.value.name
  location            = azurerm_resource_group.nsg-rg.location
  resource_group_name = azurerm_resource_group.nsg-rg.name
  address_space       = each.value.address_space

  tags = {
    owner       = each.value.tags.owner
    environment = each.value.tags.environment
  }
}

# Subnets creation and association

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.nsg-rg.name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_space

  depends_on = [
    azurerm_virtual_network.vnets
  ]
}

# NSG

resource "azurerm_network_security_group" "example" {

  for_each = var.nsg

  name                = each.value.name
  location            = azurerm_resource_group.nsg-rg.location
  resource_group_name = azurerm_resource_group.nsg-rg.name
}

# NSG Rules

resource "azurerm_network_security_rule" "example" {

  for_each = var.nsg_rules

  name                         = each.value.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_address_prefix        = each.value.source_address_prefix != "" ? each.value.source_address_prefix : null
  source_address_prefixes      = length(each.value.source_address_prefixes) != 0 ? each.value.source_address_prefixes : null
  source_port_ranges           = each.value.source_port_ranges
  destination_address_prefix   = each.value.destination_address_prefix != "" ? each.value.destination_address_prefix : null
  destination_address_prefixes = length(each.value.destination_address_prefixes) != 0 ? each.value.destination_address_prefixes : null
  destination_port_ranges      = each.value.destination_port_ranges

  resource_group_name         = azurerm_resource_group.nsg-rg.name
  network_security_group_name = each.value.nsg_name
}

# NSG - Subnet Association

locals {
  NSGs    = { for nsg in values(azurerm_network_security_group.example) : nsg.name => nsg.id }
  subnets = { for subnet in values(azurerm_subnet.subnets) : subnet.name => subnet.id }
}

resource "azurerm_subnet_network_security_group_association" "example" {

  for_each = var.nsg_subnet_associations

  subnet_id                 = [for k, v in local.subnets : v if k == each.value.subnet_name][0]
  network_security_group_id = [for k, v in local.NSGs : v if k == each.value.nsg_name][0]
}
