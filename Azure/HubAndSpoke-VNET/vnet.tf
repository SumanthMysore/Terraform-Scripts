# Resource group for vnets

resource "azurerm_resource_group" "vnet-rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

# Hub vnet

resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.hub_vnet.name
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  address_space       = var.hub_vnet.address_space

  tags = {
    owner       = var.hub_vnet.tags.owner
    environment = var.hub_vnet.tags.environment
  }
}

# Spoke vnets

resource "azurerm_virtual_network" "spoke_vnets" {
  for_each = var.spoke_vnets

  name                = each.value.name
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  address_space       = each.value.address_space

  tags = {
    owner       = each.value.tags.owner
    environment = each.value.tags.environment
  }
}

# Peering connections from Spoke vnets to Hub vnet

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each = var.spoke_vnets

  name                      = join("-to-", [each.value.name, azurerm_virtual_network.hub_vnet.name])
  resource_group_name       = azurerm_resource_group.vnet-rg.name
  virtual_network_name      = each.value.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [
    azurerm_virtual_network.hub_vnet,
    azurerm_virtual_network.spoke_vnets
  ]
}

# Peering connections from Hub vnet to Spoke vnets

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each = azurerm_virtual_network.spoke_vnets

  name                      = join("-to-", [azurerm_virtual_network.hub_vnet.name, each.value.name])
  resource_group_name       = azurerm_resource_group.vnet-rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnets[each.key].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  depends_on = [
    azurerm_virtual_network.hub_vnet,
    azurerm_virtual_network.spoke_vnets
  ]
}

# Subnets creation and association

resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.vnet-rg.name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_space

  depends_on = [
    azurerm_virtual_network.hub_vnet,
    azurerm_virtual_network.spoke_vnets
  ]
}
