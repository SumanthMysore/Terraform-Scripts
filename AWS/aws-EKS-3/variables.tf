variable "cluster" {
  default = {
    name               = "bc-112"
    kubernetes_version = "1.23"
    vpc = {
      vpc_id = "vpc-009470e55cc89e05e"
      subnet_ids = [
        "subnet-051b703b3e3db09a5",
        "subnet-08210e4584335dfda"
      ]
    }
    tags = {
      "Created By"  = "Sumanth Mysore"
      "owner"       = "sumanth.mysore@zemosolabs.com"
      "description" = "EKS Cluster created for Bootcamp-112 using Terraform"
    }
    endpoint_public_access = true
  }
}

variable "node_groups_defaults" {
  type = map(string)
  default = {
    "ami_type"      = "AL2_x86_64"
    "capacity_type" = "ON_DEMAND"
  }
}

variable "node_group" {
  type = object({
    name           = string
    instance_types = list(string)
    min_size       = number
    max_size       = number
    desired_size   = number
  })
  default = {
    name           = "bc-112-eks-node"
    instance_types = ["t3.medium"]
    min_size       = 2
    max_size       = 2
    desired_size   = 2
  }
}

variable "ingress-nginx-controller" {
  type = object({
    acm_cert_arn = string
  })
  default = {
    acm_cert_arn = "arn:aws:acm:us-east-2:365299945243:certificate/372b91a9-f14e-4ee9-bddc-6f8c34993840"
  }
}
