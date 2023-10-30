variable "resource_group" {
  type = map(string)
  default = {
    name     = "nsg-rg"
    location = "East US 2"
  }
}

variable "nsg" {
  type = map(object({
    name     = string
    location = string
  }))
  default = {
    "nsg1" = {
      name     = "spoke1-nsg"
      location = "South India"
    }
  }
}

variable "nsg_rules" {
  type = map(object({
    name                         = string
    nsg_name                     = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_ranges           = list(string)
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_port_ranges      = list(string)
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  }))
  description = "Either of address_prefix or address_prefixes should be specified. One of them should always be ignored. Giving both will lead to a conflicting error."

  validation {
    condition     = alltrue([for rule in values(var.nsg_rules) : contains(["Allow", "Deny"], rule.access)])
    error_message = "Valid values for access are Allow and Deny."
  }
  validation {
    condition     = alltrue([for rule in values(var.nsg_rules) : contains(["Inbound", "Outbound"], rule.direction)])
    error_message = "Valid values for direction are Inbound and Outbound."
  }

  default = {
    "rule1" = {
      name                       = "allowSSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefixes    = ["49.43.200.43"]
      source_port_ranges         = ["0-65535"]
      destination_address_prefix = "*"
      destination_port_ranges    = ["22"]
      nsg_name                   = "spoke1-nsg"
    },
    "rule2" = {
      name                       = "allowHTTP"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_ranges         = ["0-65535"]
      destination_address_prefix = "*"
      destination_port_ranges    = ["80"]
      nsg_name                   = "spoke1-nsg"
    }
  }
}

variable "nsg_subnet_associations" {
  type = map(object({
    nsg_name                       = string
    subnet_name                    = string
    virtual_network_name           = string
    virtual_network_resource_group = string
  }))
  default = {
    "association1" = {
      nsg_name                       = "spoke1-nsg"
      subnet_name                    = "hub01_spoke01_subnet01"
      virtual_network_name           = "hub01_spoke01"
      virtual_network_resource_group = "hub_spoke_nsg"
    },
    "association2" = {
      nsg_name                       = "spoke1-nsg"
      subnet_name                    = "hub01_spoke01_subnet02"
      virtual_network_name           = "hub01_spoke01"
      virtual_network_resource_group = "hub_spoke_nsg"
    }
  }
}
