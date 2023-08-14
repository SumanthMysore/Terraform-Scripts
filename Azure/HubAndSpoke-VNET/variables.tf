variable "resource_group" {
  type = map(string)
  default = {
    name     = "vnet-rg"
    location = "East US"
  }
}

variable "hub_vnet" {
  type = object({
    name          = string
    address_space = list(string)
    tags          = map(string)
  })
  default = {
    name          = "hub_vnet"
    address_space = ["10.0.0.0/16"]
    tags = {
      "owner"       = "sumanth.mysore@zemosolabs.com"
      "environment" = "dev"
    }
  }
}

variable "spoke_vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
    tags          = map(string)
  }))
  default = {
    "spoke_vnet1" = {
      name          = "spoke_vnet1"
      address_space = ["10.1.0.0/16"]
      tags = {
        "owner"       = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    },
    "spoke_vnet2" = {
      name          = "spoke_vnet2"
      address_space = ["10.2.0.0/16"]
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
    "hub_vnet_subnet1" = {
      name                 = "hub_vnet_subnet1"
      address_space        = ["10.0.0.0/24"]
      virtual_network_name = "hub_vnet"
    },
    "hub_vnet_subnet2" = {
      name                 = "hub_vnet_subnet2"
      address_space        = ["10.0.1.0/24"]
      virtual_network_name = "hub_vnet"
    },

    "spoke_vnet1_subnet1" = {
      name                 = "spoke_vnet1_subnet1"
      address_space        = ["10.1.0.0/24"]
      virtual_network_name = "spoke_vnet1"
    },
    "spoke_vnet1_subnet2" = {
      name                 = "spoke_vnet1_subnet2"
      address_space        = ["10.1.1.0/24"]
      virtual_network_name = "spoke_vnet1"
    },

    "spoke_vnet2_subnet1" = {
      name                 = "spoke_vnet2_subnet1"
      address_space        = ["10.2.0.0/24"]
      virtual_network_name = "spoke_vnet2"
    },
    "spoke_vnet2_subnet2" = {
      name                 = "spoke_vnet2_subnet2"
      address_space        = ["10.2.1.0/24"]
      virtual_network_name = "spoke_vnet2"
    }
  }
} 