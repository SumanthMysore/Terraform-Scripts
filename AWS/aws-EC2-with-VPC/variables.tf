variable "instance" {
  default = {
    name = "terraform-instance"
    ami  = "ami-0283a57753b18025b"
    vpc = {
      "vpc_id"    = "vpc-0064eefb47c1c855a"
      "subnet_id" = "subnet-00729b8a98fe25235"
    }
    instance_type = "t2.micro"
    storage       = 21
    tags = {
      "Created By"  = "Sumanth Mysore"
      "Description" = "EC2 instance created by terraform script."
    }
  }
}

# ssh-keygen -y -f /home/sumaM/Downloads/cicd-keypair.pem >> /home/sumaM/Downloads/terraform_ec2_key.pub

variable "public_key" {
  default = "/home/sumaM/Downloads/terraform_ec2_key.pub"
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
