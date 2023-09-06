variable "resource_group" {
  type = map(string)
  default = {
    name     = "vnet-rg-3"
    location = "East US"
  }
}

variable "vnet" {
  type = object({
    name          = string
    address_space = list(string)
    tags          = map(string)
  })
  default = {
    name          = "vnet1"
    address_space = ["11.1.0.0/16"]
    tags = {
      "owner"       = "sumanth.mysore@zemosolabs.com"
      "environment" = "dev"
    }
  }
}

variable "subnets" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
  default = {
    "subnet1" = {
      name          = "subnet1"
      address_space = ["11.1.0.0/24"]
    },
    "subnet2" = {
      name          = "subnet2"
      address_space = ["11.1.1.0/24"]
    }
  }
}

variable "nat_gateways" {
  type = map(object({
    name                    = string
    zones                   = list(string)
    idle_timeout_in_minutes = number
    public_ip = object({
      name              = string
      sku               = string
      allocation_method = string
      zones             = list(string)
    })
    subnet_name = string
  }))
  default = {
    "nat_gateway1" = {
      name                    = "natgw1"
      zones                   = ["0"]
      idle_timeout_in_minutes = 4
      public_ip = {
        name              = "natgw1-pip"
        sku               = "Standard"
        allocation_method = "Static"
        zones             = ["0"]
      }
      subnet_name = "subnet2"
    },
    # "nat_gateway2" = {
    #   name                    = "natgw2"
    #   zones                   = ["1"]
    #   idle_timeout_in_minutes = 4
    #   public_ip = {
    #     name              = "natgw2-pip"
    #     sku               = "Standard"
    #     allocation_method = "Static"
    #     zones             = ["1"]
    #   }
    #   subnet_name = "subnet1"
    # }
  }
}