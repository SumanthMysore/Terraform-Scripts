# Resource group 

resource "azurerm_resource_group" "vnet-rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags = {
    Creator     = var.resource_group.tags.Creator
    environment = var.resource_group.tags.environment
  }
}

# Spoke vnets

resource "azurerm_virtual_network" "spoke_vnets" {
  for_each = var.vwan_spoke_vnets

  name                = each.value.name
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  address_space       = each.value.address_space

  tags = {
    Creator     = each.value.tags.Creator
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
    Creator     = var.vwan.tags.Creator
    environment = var.vwan.tags.environment
  }
}

# Virtual WAN Hub

resource "azurerm_virtual_hub" "vhubs" {
  for_each = var.vwan.hubs

  name                = each.value.name
  resource_group_name = azurerm_resource_group.vnet-rg.name
  location            = azurerm_resource_group.vnet-rg.location

  virtual_wan_id                         = azurerm_virtual_wan.vwan.id
  address_prefix                         = each.value.address_space
  virtual_router_auto_scale_min_capacity = each.value.capacity

  tags = {
    Creator     = each.value.tags.Creator
    environment = each.value.tags.environment
  }
}

# Virtual WAN - VNET Connections

locals {
  vhubs       = { for k, v in azurerm_virtual_hub.vhubs : v.name => v.id }
  spoke_vnets = { for k, v in azurerm_virtual_network.spoke_vnets : v.name => v.id }
}

resource "azurerm_virtual_hub_connection" "hub_to_spokes" {
  for_each = var.vnet_connections

  name                      = "${each.value.vhub_name}_to_${each.value.vnet_name}"
  virtual_hub_id            = [for k, v in local.vhubs : v if k == each.value.vhub_name][0]
  remote_virtual_network_id = [for k, v in local.spoke_vnets : v if k == each.value.vnet_name][0]
}

# vWAN Hub - Firewall Policy

resource "azurerm_firewall_policy" "azfw_policy" {
  for_each = var.firewall_policies

  name                     = each.value.name
  location                 = azurerm_resource_group.vnet-rg.location
  resource_group_name      = azurerm_resource_group.vnet-rg.name
  sku                      = each.value.sku
  threat_intelligence_mode = each.value.threat_intelligence_mode
}

# vWAN Hub - Firewall

# locals {
#   firewall_policies = { for k,v in azazurerm_firewall_policy.azfw_policy : v.name => v.id }
# }

resource "azurerm_firewall" "fw" {
  for_each = var.firewalls

  name                = each.value.name
  location            = azurerm_resource_group.vnet-rg.location
  resource_group_name = azurerm_resource_group.vnet-rg.name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier

  virtual_hub {
    virtual_hub_id  = [for k, v in local.vhubs : v if k == each.value.vhub_name][0]
    public_ip_count = each.value.public_ip_count
  }
  firewall_policy_id = [for k, v in azurerm_firewall_policy.azfw_policy : v.id if v.name == each.value.firewall_policy_name][0]
  # firewall_policy_id = [for k,v in local.firewall_policies : v if k == each.value.firewall_policy_name][0]

  depends_on = [
    azurerm_firewall_policy.azfw_policy
  ]
}
