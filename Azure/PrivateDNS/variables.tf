variable "resource_group" {
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
  default = {
    name     = "private_dns_rg1"
    location = "South India"
    tags = {
      "Creator"     = "sumanth.mysore@zemosolabs.com"
      "environment" = "dev"
    }
  }
  description = "Resource group configuration"
}

variable "private_dns_zones" {
  type = map(object({
    name = string
    tags = map(string)
  }))
  default = {
    "zone1" = {
      name = "application.azure.net"
      tags = {
        "Creator"     = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    }
  }
  description = "Azure Private DNS Zones Configuration."
}

variable "vnet_links" {
  type = map(object({
    name                           = string
    private_dns_zone_name          = string
    virtual_network_name           = string
    virtual_network_resource_group = string
    auto_registration_enabled      = bool
    tags                           = map(string)
  }))
  default = {
    link1 = {
      name                           = "zone1-link1"
      private_dns_zone_name          = "application.azure.net"
      virtual_network_name           = "linux-vm-vnet"
      virtual_network_resource_group = "AzureLDP"
      auto_registration_enabled      = false
      tags = {
        "Creator"     = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    }
  }
  description = "Private DNS Zone Virtual network Link configuration."
}
