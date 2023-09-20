# Peering connections from Hub vnet to Spoke vnets

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  for_each = azurerm_virtual_network.spoke_vnets

  name                      = join("_To_", [azurerm_virtual_network.hub_vnet.name, each.value.name])
  resource_group_name       = azurerm_resource_group.hub-rg.name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = each.value.id
  # remote_virtual_network_id = azurerm_virtual_network.spoke_vnets[each.key].id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  depends_on = [
    azurerm_virtual_network.hub_vnet,
    azurerm_virtual_network.spoke_vnets
  ]
}

# Peering connections from Spoke vnets to Hub vnet

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  for_each = var.spoke_vnets

  name                      = join("_To_", [each.value.name, azurerm_virtual_network.hub_vnet.name])
  resource_group_name       = azurerm_resource_group.spoke-rg.name
  virtual_network_name      = each.value.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false

  depends_on = [
    azurerm_virtual_network.hub_vnet,
    azurerm_virtual_network.spoke_vnets
  ]
}
