variable "resource_group" {
  type = object({
    name     = string
    location = string
    tags     = map(string)
  })
  default = {
    name     = "connectivity_rg1"
    location = "South India"
    tags = {
      "Creator"     = "sumanth.mysore@zemosolabs.com"
      "environment" = "dev"
    }
  }
}

variable "vwan" {
  type = object({
    name        = string
    type        = string
    b2b_traffic = bool
    hubs = optional(
      map(object({
        name          = string
        address_space = string
        capacity      = number
        tags          = map(string)
      }))
    )
    tags = map(string)
  })
  default = {
    name        = "demo_vwan"
    type        = "Standard"
    b2b_traffic = true
    tags = {
      "Creator"     = "sumanth.mysore@zemosolabs.com"
      "environment" = "dev"
    }
    hubs = {
      hub1 = {
        name          = "demo_vwan_hub1"
        address_space = "11.0.0.0/16"
        capacity      = 2
        tags = {
          "Creator"     = "sumanth.mysore@zemosolabs.com"
          "environment" = "dev"
        }
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
    "spoke_vnet1" = {
      name          = "spoke_vnet1"
      address_space = ["11.1.0.0/16"]
      tags = {
        "Creator"     = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    },
    "spoke_vnet2" = {
      name          = "spoke_vnet2"
      address_space = ["11.2.0.0/16"]
      tags = {
        "Creator"     = "sumanth.mysore@zemosolabs.com"
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
    "spoke_vnet1_subnet1" = {
      name                 = "spoke_vnet1_subnet1"
      address_space        = ["11.1.0.0/24"]
      virtual_network_name = "spoke_vnet1"
    },
    "spoke_vnet1_subnet2" = {
      name                 = "spoke_vnet1_subnet2"
      address_space        = ["11.1.1.0/24"]
      virtual_network_name = "spoke_vnet1"
    },

    "spoke_vnet2_subnet1" = {
      name                 = "spoke_vnet2_subnet1"
      address_space        = ["11.2.0.0/24"]
      virtual_network_name = "spoke_vnet2"
    },
    "spoke_vnet2_subnet2" = {
      name                 = "spoke_vnet2_subnet2"
      address_space        = ["11.2.1.0/24"]
      virtual_network_name = "spoke_vnet2"
    }
  }
}

variable "vnet_connections" {
  type = map(object({
    vnet_name = string
    vhub_name = string
  }))
  default = {
    connection1 = {
      vnet_name = "spoke_vnet1"
      vhub_name = "demo_vwan_hub1"
    },
    connection2 = {
      vnet_name = "spoke_vnet2"
      vhub_name = "demo_vwan_hub1"
    }
  }
}

variable "firewalls" {
  type = map(object({
    name                 = string
    vhub_name            = optional(string)
    vnet_name            = optional(string)
    sku_name             = string
    sku_tier             = string
    firewall_policy_name = string
    public_ip_count      = number
  }))
  default = {
    "fw1" = {
      name                 = "demo_vwan_hub1_fw"
      vhub_name            = "demo_vwan_hub1"
      sku_name             = "AZFW_Hub"
      sku_tier             = "Standard"
      firewall_policy_name = "demo_vwan_hub1_fw_policy"
      public_ip_count      = 1
    }
    # "fw2" = {
    #   name = "demo_vwan_hub2_fw"
    #   vhub_name = "demo_vwan_hub2"
    #   sku_name = "AZFW_Hub"
    #   sku_tier = "Standard"
    #   firewall_policy_name = "demo_vwan_hub2_fw_policy"
    #   public_ip_count = 1
    # }
  }
  validation {
    condition     = alltrue([for firewall in values(var.firewalls) : contains(["Standard", "Premium"], firewall.sku_tier)])
    error_message = "The sku tier must be one of the following: Standard, Premium."
  }
  validation {
    condition     = alltrue([for firewall in values(var.firewalls) : contains(["AZFW_Hub", "AZFW_VNet"], firewall.sku_name)])
    error_message = "The sku name must be one of the following: AZFW_Hub, AZFW_VNet."
  }
}

variable "firewall_policies" {
  type = map(object({
    name                     = string
    sku                      = string
    threat_intelligence_mode = string
    tags                     = map(string)
  }))
  default = {
    "policy1" = {
      name                     = "demo_vwan_hub1_fw_policy"
      sku                      = "Standard"
      threat_intelligence_mode = "Alert"
      tags = {
        "Creator"     = "sumanth.mysore@zemosolabs.com"
        "environment" = "dev"
      }
    }
    # "policy2" = {
    #   name = "demo_vwan_hub2_fw_policy"
    #   sku = "Standard"
    #   threat_intelligence_mode = "Alert"
    #   tags = {
    #     "Creator"     = "sumanth.mysore@zemosolabs.com"
    #     "environment" = "dev"
    #   }
    # }
  }
}
