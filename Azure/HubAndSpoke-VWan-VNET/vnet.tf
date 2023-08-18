# Resource group for vnets

resource "azurerm_resource_group" "vnet-rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
}

# Spoke vnets

resource "azurerm_virtual_network" "spoke_vnets" {
  for_each = var.vwan_spoke_vnets

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
    azurerm_virtual_network.spoke_vnets
  ]
}

# Virtual WAN

resource "azurerm_virtual_wan" "vwan" {
  name                = var.vwan.name
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location

  type                           = var.vwan.type
  allow_branch_to_branch_traffic = var.vwan.b2b_traffic

  tags = {
    owner       = var.vwan.tags.owner
    environment = var.vwan.tags.environment
  }
}

# Virtual WAN Hub

resource "azurerm_virtual_hub" "vhub1" {

  name                = var.vwan.hub.name
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location

  virtual_wan_id                         = azurerm_virtual_wan.vwan.id
  address_prefix                         = var.vwan.hub.address_space
  virtual_router_auto_scale_min_capacity = var.vwan.hub.capacity

  tags = {
    owner       = var.vwan.hub.tags.owner
    environment = var.vwan.hub.tags.environment
  }
}

# Virtual WAN - VNET Connections

resource "azurerm_virtual_hub_connection" "hub_to_spokes" {
  for_each = azurerm_virtual_network.spoke_vnets

  name                      = "${azurerm_virtual_hub.vhub1.name}_to_${azurerm_virtual_network.spoke_vnets[each.key].name}"
  virtual_hub_id            = azurerm_virtual_hub.vhub1.id
  remote_virtual_network_id = azurerm_virtual_network.spoke_vnets[each.key].id
}
