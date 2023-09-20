variable "hub_resource_group" {
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
  description = "Configuration for the Hub Resource Group"
}

variable "spokes_resource_group" {
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
  description = "Configuration for the Spokes Resource Group"
}

variable "hub_vnet" {
  type = object({
    name          = string
    address_space = list(string)
    tags          = map(string)
  })
  description = "Configuration for the Hub Virtual Network"
}

variable "spoke_vnets" {
  type = map(object({
    name          = string
    address_space = list(string)
    tags          = map(string)
  }))
  description = "Configuration for the Spoke Virtual Networks"
}

variable "hub-subnets" {
  type = map(object({
    name                 = string
    address_space        = list(string)
    virtual_network_name = string
  }))
  description = "Configuration for the Subnets in the Hub Virtual Network"
}

variable "spoke-subnets" {
  type = map(object({
    name                 = string
    address_space        = list(string)
    virtual_network_name = string
  }))
  description = "Configuration for the Subnets in the Spoke Virtual Networks"
}
