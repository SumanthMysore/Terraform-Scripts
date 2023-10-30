variable "resource_group" {
  type = map(string)
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
  }))
}

variable "nat_gateway_subnet_associations" {
  type = map(object({
    nat_gateway_name     = string
    subnet_name          = string
    virtual_network_name = string
    resource_group_name  = string
  }))
}
