hub_resource_group = {
  name     = "vnet-hub-re1"
  location = "East US"
  tags = {
    "Creator" = "Sumanth Mysore"
  }
}

spokes_resource_group = {
  name     = "vnet-spoke-re1"
  location = "East US"
  tags = {
    "Creator" = "Sumanth Mysore"
  }
}

hub_vnet = {
  name          = "hub-re1"
  address_space = ["10.10.100.0/24"]
  tags = {
    "Creator"     = "Sumanth Mysore"
    "environment" = "sandbox"
  }
}

spoke_vnets = {
  "spoke_vnet1" = {
    name          = "spoke-re1"
    address_space = ["10.11.100.0/24"]
    tags = {
      "Creator"     = "Sumanth Mysore"
      "environment" = "sandbox"
    }
  },
  "spoke_vnet2" = {
    name          = "spoke-re2"
    address_space = ["10.11.101.0/24"]
    tags = {
      "Creator"     = "Sumanth Mysore"
      "environment" = "dev"
    }
  },
}

hub-subnets = {
  "hub_vnet_subnet1" = {
    name                 = "jumphost"
    address_space        = ["10.10.100.0/26"]
    virtual_network_name = "hub-re1"
  },
  "hub_vnet_subnet2" = {
    name                 = "webapp-presentation-tier"
    address_space        = ["10.10.100.64/26"]
    virtual_network_name = "hub-re1"
  },
  "hub_vnet_subnet3" = {
    name                 = "GatewaySubnet"
    address_space        = ["10.10.100.128/26"]
    virtual_network_name = "hub-re1"
  },
  "hub_vnet_subnet4" = {
    name                 = "AzureFirewallSubnet"
    address_space        = ["10.10.100.192/26"]
    virtual_network_name = "hub-re1"
  },
}

spoke-subnets = {
  "spoke_vnet1_subnet1" = {
    name                 = "jumphost"
    address_space        = ["10.11.100.0/25"]
    virtual_network_name = "spoke-re1"
  },
  "spoke_vnet1_subnet2" = {
    name                 = "webapp-presentation-tier"
    address_space        = ["10.11.100.128/25"]
    virtual_network_name = "spoke-re1"
  },

  "spoke_vnet2_subnet1" = {
    name                 = "jumphost"
    address_space        = ["10.11.101.0/25"]
    virtual_network_name = "spoke-re2"
  },
  "spoke_vnet2_subnet2" = {
    name                 = "webapp-presentation-tier"
    address_space        = ["10.11.101.128/25"]
    virtual_network_name = "spoke-re2"
  }
}
