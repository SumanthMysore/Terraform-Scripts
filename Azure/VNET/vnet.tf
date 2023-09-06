# Resource group for vnets

resource "azurerm_resource_group" "vnet-rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

# vnets

resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets

  name                = each.value.name
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
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
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_space

  depends_on = [
    azurerm_virtual_network.vnets
  ]
}
