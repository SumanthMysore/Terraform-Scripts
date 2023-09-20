output "hub_vnet_info" {
  value = {
    name = azurerm_virtual_network.hub_vnet.name
    id   = azurerm_virtual_network.hub_vnet.id
    cidr = azurerm_virtual_network.hub_vnet.address_space[0]
  }
  description = "Information about the Hub Virtual Network"
}

output "spoke_vnets_info" {
  value = {
    for key, vnet in azurerm_virtual_network.spoke_vnets :
    key => {
      name = vnet.name
      id   = vnet.id
      cidr = vnet.address_space[0]
    }
  }
  description = "Information about the Spoke Virtual Networks"
}

output "hub_vnet_subnets_info" {
  value = {
    for key, subnet in azurerm_subnet.hub-subnets :
    key => {
      name          = subnet.name
      id            = subnet.id
      cidr          = subnet.address_prefixes[0]
      associated_to = subnet.virtual_network_name
    }
  }
  description = "Information about the Subnets in the Hub Virtual Network"
}

output "spoke_vnet_subnets_info" {
  value = {
    for key, subnet in azurerm_subnet.spoke-subnets :
    key => {
      name          = subnet.name
      id            = subnet.id
      cidr          = subnet.address_prefixes[0]
      associated_to = subnet.virtual_network_name
    }
  }
  description = "Information about the Subnets in the Spoke Virtual Networks"
}
