# Resource group 

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags = {
    Creator     = var.resource_group.tags.Creator
    environment = var.resource_group.tags.environment
  }
}

# Private DNS Zone

resource "azurerm_private_dns_zone" "zones" {
  for_each = var.private_dns_zones

  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  tags = {
    Creator     = each.value.tags.Creator
    environment = each.value.tags.environment
  }
}

# Private DNS Zone - VNET link

data "azurerm_virtual_network" "vnets" {
  for_each = var.vnet_links

  name                = each.value.virtual_network_name
  resource_group_name = each.value.virtual_network_resource_group
}

locals {
  vnets = { for k, v in data.azurerm_virtual_network.vnets : v.name => v.id }
}

resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each = var.vnet_links

  name                  = each.value.name
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = each.value.private_dns_zone_name
  virtual_network_id    = [for k, v in local.vnets : v if k == each.value.virtual_network_name][0]
  registration_enabled  = each.value.auto_registration_enabled
  tags = {
    Creator     = each.value.tags.Creator
    environment = each.value.tags.environment
  }
  depends_on = [
    azurerm_private_dns_zone.zones
  ]
}
