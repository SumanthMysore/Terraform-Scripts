variable "instance" {
  default = {
    name          = "docker-test2"
    ami           = "ami-0283a57753b18025b"
    instance_type = "t2.micro"
    storage       = 21
    tags = {
      "Created By"  = "Sumanth Mysore"
      "owner"       = "sumanth.mysore@zemosolabs.com"
      "description" = "EC2 instance created by terraform script."
    }
  }
}

# ssh-keygen -y -f /home/sumaM/Downloads/sumanthmysore.pem >> /home/sumaM/Downloads/terraform_ec2_public_key.pub

variable "public_key" {
  default = "/home/sumaM/Downloads/terraform_ec2_public_key.pub"
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
  }))
  default = [
    {
      from_port  = 22
      to_port    = 22
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    },
    {
      from_port  = 80
      to_port    = 80
      protocol   = "tcp"
      cidr_block = "0.0.0.0/0"
    },
  ]
}