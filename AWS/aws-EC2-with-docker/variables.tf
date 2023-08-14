variable "instance" {
  default = {
    name          = "bc-87"
    ami           = "ami-0283a57753b18025b"
    instance_type = "t3.large"
    storage       = 30
    tags = {
      "Created By"  = "Sumanth Mysore"
      "owner"       = "sumanth.mysore@zemosolabs.com"
      "description" = "EC2 instance created by terraform script."
    }
    key_name = "sumanthmysore"
  }
}

variable "private_key" {
  default = "/home/sumaM/Downloads/sumanthmysore.pem"
}

variable "inbound_rules" {
  type = list(object({
    from_port  = number
    to_port    = number
    protocol   = string
    cidr_block = string
    description = string
  }))
  default = [
    {
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
      description = "For SSH connection"
    },
    {
      from_port  = 80
      to_port    = 80
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
      description = "To expose frontend application"
    },
    {
      from_port  = 3005
      to_port    = 3005
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
      description = "To expose mockserver application"
    },
    {
      from_port  = 3306
      to_port    = 3306
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
      description = "For MySQL database connection"
    },
  ]
}