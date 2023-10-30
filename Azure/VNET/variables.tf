variable "resource_group" {
  type = map(string)
  default = {
    name     = "sumanthmysore-rg1"
    location = "East US"
  }
}

variable "vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
    tags          = map(string)
  }))
  default = {
    "vnet1" = {
      name          = "vnet1"
      address_space = ["11.1.0.0/16"]
      tags = {
        "owner"       = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    },
    # "vnet2" = {
    #   name          = "vnet2"
    #   address_space = ["11.2.0.0/16"]
    #   tags = {
    #     "owner"       = "sumanth.mysore@zemosolabs.com"
    #     "environment" = "dev"
    #   }
    # },
  }
}

variable "subnets" {
  type = map(object({
    name                 = string
    address_space        = list(string)
    virtual_network_name = string
  }))
  default = {
    "vnet1_subnet1" = {
      name                 = "vnet1_subnet1"
      address_space        = ["11.1.0.0/24"]
      virtual_network_name = "vnet1"
    },
    "vnet1_subnet2" = {
      name                 = "vnet1_subnet2"
      address_space        = ["11.1.1.0/24"]
      virtual_network_name = "vnet1"
    },

    # "vnet2_subnet1" = {
    #   name                 = "vnet2_subnet1"
    #   address_space        = ["11.2.0.0/24"]
    #   virtual_network_name = "vnet2"
    # },
    # "vnet2_subnet2" = {
    #   name                 = "vnet2_subnet2"
    #   address_space        = ["11.2.1.0/24"]
    #   virtual_network_name = "vnet2"
    # }
  }
}
