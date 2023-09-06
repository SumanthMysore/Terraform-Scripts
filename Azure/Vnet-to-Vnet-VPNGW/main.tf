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

# VPN Gateway

module "vnet-gateway" {
  source  = "Azure/vnet-gateway/azurerm"
  version = "0.1.2"

  for_each = var.vnet_gateways

  location                            = each.value.virtual_network_location
  name                                = each.value.name
  sku                                 = each.value.sku
  vpn_generation                      = each.value.generation
  subnet_address_prefix               = each.value.gateway_subnet_address_prefix
  type                                = each.value.type
  virtual_network_name                = each.value.virtual_network_name
  virtual_network_resource_group_name = each.value.virtual_network_resource_group_name
  vpn_active_active_enabled           = each.value.vpn_active_active_enabled
  ip_configurations = {
    public_ip = {
      name              = each.value.public_ip.name
      allocation_method = each.value.public_ip.allocation_method
      sku               = each.value.public_ip.sku
    }
  }

  depends_on = [
    azurerm_virtual_network.vnets
  ]
}

locals {
  vpn_gateways = keys(module.vnet-gateway)
}

# Vnet-to-Vnet Connection

resource "azurerm_virtual_network_gateway_connection" "Vnet2Vnet" {

  for_each = var.Connections

  name                            = each.value.connection_name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group
  type                            = each.value.connection_type
  virtual_network_gateway_id      = [for vpn_gateway in local.vpn_gateways : module.vnet-gateway[vpn_gateway].virtual_network_gateway.id if module.vnet-gateway[vpn_gateway].virtual_network_gateway.name == each.value.gateway1_name][0]
  peer_virtual_network_gateway_id = [for vpn_gateway in local.vpn_gateways : module.vnet-gateway[vpn_gateway].virtual_network_gateway.id if module.vnet-gateway[vpn_gateway].virtual_network_gateway.name == each.value.gateway2_name][0]
  shared_key                      = each.value.shared_key
}
