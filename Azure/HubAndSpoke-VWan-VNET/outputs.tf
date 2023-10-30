output "virtual_wan_info" {
  value = {
    name     = azurerm_virtual_wan.vwan.name
    id       = azurerm_virtual_wan.vwan.id
    location = azurerm_virtual_wan.vwan.location
    type     = azurerm_virtual_wan.vwan.type
  }
  description = "Information about the Virtual WAN"
}

output "virtual_hub_info" {
  value = {
    for key, hub in azurerm_virtual_hub.vhubs :
    key => {
      name                                   = hub.name
      id                                     = hub.id
      address_prefix                         = hub.address_prefix
      virtual_router_auto_scale_min_capacity = hub.virtual_router_auto_scale_min_capacity
    }
  }
  description = "Information about the Virtual WAN Hubs"
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

output "subnet_info" {
  value = {
    for key, subnet in azurerm_subnet.subnets :
    key => {
      name                 = subnet.name
      id                   = subnet.id
      address_prefixes     = subnet.address_prefixes[0]
      virtual_network_name = subnet.virtual_network_name
    }
  }
  description = "Information about the Subnets"
}

output "virtual_hub_connection_info" {
  value = {
    for key, connection in azurerm_virtual_hub_connection.hub_to_spokes :
    key => {
      name                      = connection.name
      virtual_hub_id            = connection.virtual_hub_id
      remote_virtual_network_id = connection.remote_virtual_network_id
    }
  }
  description = "Information about the Virtual Hub to Spoke VNet Connections"
}

output "firewall_policy_info" {
  value = {
    for key, policy in azurerm_firewall_policy.azfw_policy :
    key => {
      name                     = policy.name
      sku                      = policy.sku
      threat_intelligence_mode = policy.threat_intelligence_mode
    }
  }
  description = "Information about the Firewall Policies"
}

output "firewall_info" {
  value = {
    for key, firewall in azurerm_firewall.fw :
    key => {
      name               = firewall.name
      sku_name           = firewall.sku_name
      sku_tier           = firewall.sku_tier
      virtual_hub_id     = firewall.virtual_hub[0].virtual_hub_id
      public_ip_count    = firewall.virtual_hub[0].public_ip_count
      firewall_policy_id = firewall.firewall_policy_id
    }
  }
  description = "Information about the Firewalls"
}
