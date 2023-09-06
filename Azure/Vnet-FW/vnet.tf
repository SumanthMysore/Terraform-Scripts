# Taking existing Resource group for vnets

data "azurerm_resource_group" "vnet-rg" {
  name = var.resource_group.name
}

# vnets

resource "azurerm_virtual_network" "vnets" {
  for_each = var.vnets

  name                = each.value.name
  location            = data.azurerm_resource_group.vnet-rg.location
  resource_group_name = data.azurerm_resource_group.vnet-rg.name
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
  resource_group_name  = data.azurerm_resource_group.vnet-rg.name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_space

  depends_on = [
    azurerm_virtual_network.vnets
  ]
}

# Firewall Public IP 

resource "azurerm_public_ip" "fw_pips" {

  for_each = var.basic_sku_FWs

  name                = each.value.fw_pip.name
  location            = data.azurerm_resource_group.vnet-rg.location
  resource_group_name = data.azurerm_resource_group.vnet-rg.name
  allocation_method   = each.value.fw_pip.allocation_method
  sku                 = each.value.fw_pip.sku
}

# Firewall Management Public IP

resource "azurerm_public_ip" "fw_management_pips" {

  for_each = var.basic_sku_FWs

  name                = each.value.fw_management_pip.name
  location            = data.azurerm_resource_group.vnet-rg.location
  resource_group_name = data.azurerm_resource_group.vnet-rg.name
  allocation_method   = each.value.fw_management_pip.allocation_method
  sku                 = each.value.fw_management_pip.sku
}

# Firewall Policy

resource "azurerm_firewall_policy" "basic_sku_fw_policies" {

  for_each = var.basic_sku_FWs

  name                = each.value.firewall_policy.name
  location            = data.azurerm_resource_group.vnet-rg.location
  resource_group_name = data.azurerm_resource_group.vnet-rg.name
  sku                 = each.value.firewall_policy.sku
}

locals {
  subnets               = keys(azurerm_subnet.subnets)
  fw_pips               = keys(azurerm_public_ip.fw_pips)
  fw_management_pips    = keys(azurerm_public_ip.fw_management_pips)
  basic_sku_fw_policies = keys(azurerm_firewall_policy.basic_sku_fw_policies)
}

# Firewall

resource "azurerm_firewall" "basic_sku_FWs" {

  for_each = var.basic_sku_FWs

  name                = each.value.name
  location            = data.azurerm_resource_group.vnet-rg.location
  resource_group_name = data.azurerm_resource_group.vnet-rg.name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier

  ip_configuration {
    name                 = each.value.fw_pip.name
    subnet_id            = [for subnet in local.subnets : azurerm_subnet.subnets[subnet].id if(azurerm_subnet.subnets[subnet].name == "AzureFirewallSubnet" && azurerm_subnet.subnets[subnet].virtual_network_name == each.value.virtual_network_name)][0]
    public_ip_address_id = [for fw_pip in local.fw_pips : azurerm_public_ip.fw_pips[fw_pip].id if azurerm_public_ip.fw_pips[fw_pip].name == each.value.fw_pip.name][0]
  }

  management_ip_configuration {
    name                 = each.value.fw_management_pip.name
    subnet_id            = [for subnet in local.subnets : azurerm_subnet.subnets[subnet].id if(azurerm_subnet.subnets[subnet].name == "AzureFirewallManagementSubnet" && azurerm_subnet.subnets[subnet].virtual_network_name == each.value.virtual_network_name)][0]
    public_ip_address_id = [for fw_management_pip in local.fw_management_pips : azurerm_public_ip.fw_management_pips[fw_management_pip].id if azurerm_public_ip.fw_management_pips[fw_management_pip].name == each.value.fw_management_pip.name][0]
  }

  firewall_policy_id = [for policy in local.basic_sku_fw_policies : azurerm_firewall_policy.basic_sku_fw_policies[policy].id if azurerm_firewall_policy.basic_sku_fw_policies[policy].name == each.value.firewall_policy.name][0]
}

