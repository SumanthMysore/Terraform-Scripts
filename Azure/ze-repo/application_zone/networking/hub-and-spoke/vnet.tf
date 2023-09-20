# Resource group for Hub

resource "azurerm_resource_group" "hub-rg" {
  name     = var.hub_resource_group.name
  location = var.hub_resource_group.location
  tags = {
    Creator = var.hub_resource_group.tags.Creator
  }
}

# Resource group for Spokes

resource "azurerm_resource_group" "spoke-rg" {
  name     = var.spokes_resource_group.name
  location = var.spokes_resource_group.location
  tags = {
    Creator = var.spokes_resource_group.tags.Creator
  }
}

# Hub vnet

resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_vnet.name
  location            = azurerm_resource_group.hub-rg.location
  resource_group_name = azurerm_resource_group.hub-rg.name
  address_space       = var.hub_vnet.address_space

  tags = {
    Creator     = var.hub_vnet.tags.Creator
    environment = var.hub_vnet.tags.environment
  }
}

# Spoke vnets

resource "azurerm_virtual_network" "spoke_vnets" {
  for_each = var.spoke_vnets

  name                = each.value.name
  location            = azurerm_resource_group.spoke-rg.location
  resource_group_name = azurerm_resource_group.spoke-rg.name
  address_space       = each.value.address_space

  tags = {
    Creator     = each.value.tags.Creator
    environment = each.value.tags.environment
  }
}

# Subnets creation and association

resource "azurerm_subnet" "hub-subnets" {
  for_each = var.hub-subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.hub-rg.name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_space

  depends_on = [
    azurerm_virtual_network.hub_vnet
  ]
}

resource "azurerm_subnet" "spoke-subnets" {
  for_each = var.spoke-subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.spoke-rg.name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_space

  depends_on = [
    azurerm_virtual_network.spoke_vnets
  ]
}
