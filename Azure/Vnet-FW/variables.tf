variable "resource_group" {
  type = map(string)
  default = {
    name = "firewall-rg"
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
      name                 = "vnet1_subnet1"
      address_space        = ["11.1.0.0/24"]
      virtual_network_name = "vnet1"
    },
    "vnet1_subnet2" = {
      name                 = "AzureFirewallManagementSubnet"
      address_space        = ["11.1.1.0/26"]
      virtual_network_name = "vnet1"
    },
    "vnet1_subnet3" = {
      name                 = "AzureFirewallSubnet"
      address_space        = ["11.1.2.0/26"]
      virtual_network_name = "vnet1"
    }
  }
}

variable "basic_sku_FWs" {
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
    fw_management_pip = object({
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
      name                 = "test_fw"
      virtual_network_name = "vnet1"
      sku_name             = "AZFW_VNet"
      sku_tier             = "Basic"
      fw_pip = {
        name              = "test_fw_pip"
        allocation_method = "Static"
        sku               = "Standard"
      }
      fw_management_pip = {
        name              = "test_fw_management_pip"
        allocation_method = "Static"
        sku               = "Standard"
      }
      firewall_policy = {
        name = "test_fw_policy"
        sku  = "Basic"
      }
    }
  }
}

