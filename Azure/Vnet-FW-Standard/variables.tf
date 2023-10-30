variable "resource_group" {
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
  default = {
    name     = "connectivity_rg2"
    location = "South India"
    tags = {
      "Creator"     = "sumanth.mysore@zemosolabs.com"
      "environment" = "dev"
    }
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
      name          = "SecureVnet1"
      address_space = ["10.0.0.0/16"]
      tags = {
        "Creator"     = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    }
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
      name                 = "SecureVnet1_subnet1"
      address_space        = ["10.0.0.0/24"]
      virtual_network_name = "SecureVnet1"
    },
    "vnet1_subnet2" = {
      name                 = "AzureFirewallSubnet"
      address_space        = ["10.0.1.0/26"]
      virtual_network_name = "SecureVnet1"
    }
  }
}

variable "standard_sku_FWs" {
  type = map(object({
    name                 = string
    virtual_network_name = string
    sku_name             = string
    sku_tier             = string
    fw_pip = object({
      name              = string
      allocation_method = string
      sku               = string
    })
    firewall_policy = object({
      name = string
      sku  = string
    })
  }))
  default = {
    "fw1" = {
      name                 = "fw-secure"
      virtual_network_name = "SecureVnet1"
      sku_name             = "AZFW_VNet"
      sku_tier             = "Standard"
      fw_pip = {
        name              = "fw-secure-pip"
        allocation_method = "Static"
        sku               = "Standard"
      }
      firewall_policy = {
        name = "fw-secure-policy"
        sku  = "Standard"
      }
    }
  }
}
