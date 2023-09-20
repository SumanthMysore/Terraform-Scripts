resource_group = {
  name     = "nat-rg"
  location = "East US"
}

vnet = {
  name          = "vnet1"
  address_space = ["11.1.0.0/16"]
  tags = {
    "owner"       = "sumanth.mysore@zemosolabs.com"
    "environment" = "dev"
  }
}

subnets = {
  "subnet1" = {
    name          = "subnet1"
    address_space = ["11.1.0.0/24"]
  },
  "subnet2" = {
    name          = "subnet2"
    address_space = ["11.1.1.0/24"]
  }
}

nat_gateways = {
  "nat_gateway1" = {
    name                    = "natgw1"
    idle_timeout_in_minutes = 4
    public_ip = {
      name              = "natgw1-pip"
      sku               = "Standard"
      allocation_method = "Static"
    }
    subnet_name = "webapp-presentation-tier"
  },
}

existing_subnets = {
  "subnet1" = {
    name                 = "webapp-presentation-tier"
    virtual_network_name = "spoke-re1"
    resource_group_name  = "vnet-spoke-re1"
  }
}
