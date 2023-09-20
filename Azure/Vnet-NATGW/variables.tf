variable "resource_group" {
  type = map(string)
}

variable "vnet" {
  type = object({
    name          = string
    address_space = list(string)
    tags          = map(string)
  })
}

variable "subnets" {
  type = map(object({
    name          = string
    address_space = list(string)
  }))
}

variable "nat_gateways" {
  type = map(object({
    name                    = string
    idle_timeout_in_minutes = number
    public_ip = object({
      name              = string
      sku               = string
      allocation_method = string
    })
    subnet_name = string
  }))
}

variable "existing_subnets" {
  type = map(object({
    name                 = string
    virtual_network_name = string
    resource_group_name  = string
  }))
}