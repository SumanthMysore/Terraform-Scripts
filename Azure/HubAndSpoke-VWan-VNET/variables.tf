variable "resource_group" {
  type = map(string)
  default = {
    name     = "vnet-vwan-rg"
    location = "East US"
  }
}

variable "vwan" {
  type = object({
    name        = string
    type        = string
    b2b_traffic = bool
    hub = object({
      name          = string
      address_space = string
      capacity      = number
      tags          = map(string)
    })
    tags = map(string)
  })
  default = {
    name        = "test-vwan"
    type        = "Standard"
    b2b_traffic = true
    tags = {
      "owner"       = "sumanth.mysore@zemosolabs.com"
      "environment" = "dev"
    }
    hub = {
      name          = "test-vwan-hub1"
      address_space = "11.0.0.0/16"
      capacity      = 2
      tags = {
        "owner"       = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    }
  }
}

variable "vwan_spoke_vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
    tags          = map(string)
  }))
  default = {
    "vwan_spoke_vnet1" = {
      name          = "vwan_spoke_vnet1"
      address_space = ["11.1.0.0/16"]
      tags = {
        "owner"       = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    },
    "vwan_spoke_vnet2" = {
      name          = "vwan_spoke_vnet2"
      address_space = ["11.2.0.0/16"]
      tags = {
        "owner"       = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    },
  }
}

variable "subnets" {
  type = map(object({
    name                 = string
    address_space        = list(string)
    virtual_network_name = string
  }))
  default = {
    "vwan_spoke_vnet1_subnet1" = {
      name                 = "vwan_spoke_vnet1_subnet1"
      address_space        = ["11.1.0.0/24"]
      virtual_network_name = "vwan_spoke_vnet1"
    },
    "vwan_spoke_vnet1_subnet2" = {
      name                 = "vwan_spoke_vnet1_subnet2"
      address_space        = ["11.1.1.0/24"]
      virtual_network_name = "vwan_spoke_vnet1"
    },

    "vwan_spoke_vnet2_subnet1" = {
      name                 = "vwan_spoke_vnet2_subnet1"
      address_space        = ["11.2.0.0/24"]
      virtual_network_name = "vwan_spoke_vnet2"
    },
    "vwan_spoke_vnet2_subnet2" = {
      name                 = "vwan_spoke_vnet2_subnet2"
      address_space        = ["11.2.1.0/24"]
      virtual_network_name = "vwan_spoke_vnet2"
    }
  }
}
