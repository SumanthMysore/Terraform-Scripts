variable "resource_group" {
  type = map(string)
  default = {
    name     = "nsg-rg"
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
    }
  }
}

variable "nsg" {
  type = map(map(string))
  default = {
    "nsg1" = {
      "name" = "test-nsg-1"
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
    destination_port_ranges      = list(string)
    source_address_prefix        = string
    source_address_prefixes      = list(string)
    destination_address_prefix   = string
    destination_address_prefixes = list(string)
  }))
  description = "Either of address_prefix or address_prefixes should be specified. One of them should always be empty. Giving both will lead to a conflicting error."

  validation {
    condition     = alltrue([for rule in values(var.nsg_rules) : contains(["Allow", "Deny"], rule.access)])
    error_message = "Valid values for access are Allow and Deny."
  }
  validation {
    condition     = alltrue([for rule in values(var.nsg_rules) : contains(["Inbound", "Outbound"], rule.direction)])
    error_message = "Valid values for direction are Inbound and Outbound."
  }
  validation {
    condition     = alltrue([for rule in values(var.nsg_rules) : contains(["Tcp", "Udp", "Icmp", "Esp", "Ah", "*"], rule.protocol)])
    error_message = "Valid values for protocol are Tcp, Udp, Icmp, Esp, Ah or *."
  }

  default = {
    "rule1" = {
      name                         = "allowSSH"
      priority                     = 100
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_address_prefix        = ""
      source_address_prefixes      = ["49.43.200.43"]
      source_port_ranges           = ["0-65535"]
      destination_address_prefix   = "*"
      destination_address_prefixes = []
      destination_port_ranges      = ["22"]
      nsg_name                     = "test-nsg-1"
    },
    "rule2" = {
      name                         = "allowHTTP"
      priority                     = 101
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_address_prefix        = ""
      source_address_prefixes      = ["49.43.200.43"]
      source_port_ranges           = ["0-65535"]
      destination_address_prefix   = "*"
      destination_address_prefixes = []
      destination_port_ranges      = ["80"]
      nsg_name                     = "test-nsg-1"
    }
  }
}

variable "nsg_subnet_associations" {
  type = map(object({
    nsg_name    = string
    subnet_name = string
  }))
  default = {
    "association1" = {
      nsg_name    = "test-nsg-1"
      subnet_name = "vnet1_subnet1"
    }
  }
}
