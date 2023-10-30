# RG for NSG

resource "azurerm_resource_group" "nsg-rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

# NSG

resource "azurerm_network_security_group" "nsg" {

  for_each = var.nsg

  name                = each.value.name
  location            = each.value.location
  resource_group_name = azurerm_resource_group.nsg-rg.name
}

# NSG Rules

resource "azurerm_network_security_rule" "rules" {

  for_each = var.nsg_rules

  name                         = each.value.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_address_prefix        = each.value.source_address_prefix
  source_address_prefixes      = each.value.source_address_prefixes
  source_port_ranges           = each.value.source_port_ranges
  destination_address_prefix   = each.value.destination_address_prefix
  destination_address_prefixes = each.value.destination_address_prefixes
  destination_port_ranges      = each.value.destination_port_ranges

  resource_group_name         = azurerm_resource_group.nsg-rg.name
  network_security_group_name = each.value.nsg_name

  depends_on = [ 
    azurerm_network_security_group.nsg 
  ]
}

# NSG - Subnet Association

locals {
  NSGs = { for nsg in values(azurerm_network_security_group.nsg) : nsg.name => nsg.id }
}

data "azurerm_subnet" "subnets" {
  for_each = var.nsg_subnet_associations

  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.virtual_network_resource_group
}

resource "azurerm_subnet_network_security_group_association" "example" {

  for_each = var.nsg_subnet_associations

  subnet_id                 = [for k, subnet in data.azurerm_subnet.subnets : subnet.id if(subnet.name == each.value.subnet_name && subnet.virtual_network_name == each.value.virtual_network_name)][0]
  network_security_group_id = [for k, v in local.NSGs : v if k == each.value.nsg_name][0]
}
