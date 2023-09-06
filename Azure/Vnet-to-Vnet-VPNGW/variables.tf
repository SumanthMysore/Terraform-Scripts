variable "resource_group" {
  type = map(string)
  default = {
    name     = "tf-vnet-rg"
    location = "East US 2"
  }
}

variable "vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
    tags          = map(string)
  }))
  default = {
    "tf-vnet1" = {
      name          = "tf-vnet1"
      address_space = ["12.1.0.0/16"]
      tags = {
        "owner"       = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    },
    "tf-vnet2" = {
      name          = "tf-vnet2"
      address_space = ["12.2.0.0/16"]
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
    "tf-vnet1_subnet1" = {
      name                 = "tf-vnet1_subnet1"
      address_space        = ["12.1.0.0/24"]
      virtual_network_name = "tf-vnet1"
    },
    "tf-vnet1_subnet2" = {
      name                 = "tf-vnet1_subnet2"
      address_space        = ["12.1.1.0/24"]
      virtual_network_name = "tf-vnet1"
    },

    "tf-vnet2_subnet1" = {
      name                 = "tf-vnet2_subnet1"
      address_space        = ["12.2.0.0/24"]
      virtual_network_name = "tf-vnet2"
    },
    "tf-vnet2_subnet2" = {
      name                 = "tf-vnet2_subnet2"
      address_space        = ["12.2.1.0/24"]
      virtual_network_name = "tf-vnet2"
    }
  }
}

variable "vnet_gateways" {
  type = map(object({
    name                                = string
    type                                = string
    sku                                 = string
    generation                          = string
    virtual_network_name                = string
    virtual_network_location            = string
    virtual_network_resource_group_name = string
    gateway_subnet_address_prefix       = string
    vpn_active_active_enabled           = bool
    public_ip                           = map(string)
  }))
  default = {
    gateway1 = {
      name                                = "tf-vnet1-GW"
      type                                = "Vpn"
      sku                                 = "Basic"
      generation                          = "Generation1"
      virtual_network_name                = "tf-vnet1"
      virtual_network_location            = "East US 2"
      virtual_network_resource_group_name = "tf-vnet-rg"
      gateway_subnet_address_prefix       = "12.1.2.0/24"
      vpn_active_active_enabled           = false
      public_ip = {
        name              = "tf-vnet1-GW-PIP"
        allocation_method = "Dynamic"
        sku               = "Basic"
      }
    },
    gateway2 = {
      name                                = "tf-vnet2-GW"
      type                                = "Vpn"
      sku                                 = "Basic"
      generation                          = "Generation1"
      virtual_network_name                = "tf-vnet2"
      virtual_network_location            = "East US 2"
      virtual_network_resource_group_name = "tf-vnet-rg"
      gateway_subnet_address_prefix       = "12.2.2.0/24"
      vpn_active_active_enabled           = false
      public_ip = {
        name              = "tf-vnet2-GW-PIP"
        allocation_method = "Dynamic"
        sku               = "Basic"
      }
    }
  }
}

variable "Connections" {
  type = map(object({
    connection_name = string
    connection_type = string
    resource_group  = string
    location        = string
    shared_key      = string
    gateway1_name   = string
    gateway2_name   = string
  }))
  default = {
    connection1 = {
      connection_name = "tf-vnet1-to-tf-vnet2"
      connection_type = "Vnet2Vnet"
      resource_group  = "tf-vnet-rg"
      location        = "East US 2"
      gateway1_name   = "tf-vnet1-GW"
      gateway2_name   = "tf-vnet2-GW"
      shared_key      = "abc-TesT-456"
    },
    connection2 = {
      connection_name = "tf-vnet2-to-tf-vnet1"
      connection_type = "Vnet2Vnet"
      resource_group  = "tf-vnet-rg"
      location        = "East US 2"
      gateway1_name   = "tf-vnet2-GW"
      gateway2_name   = "tf-vnet1-GW"
      shared_key      = "abc-TesT-456"
    }
  }
}
