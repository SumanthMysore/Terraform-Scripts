variable "cluster" {
  default = {
    name               = "bc-71"
    kubernetes_version = "1.23"
    vpc = {
      vpc_id     = "vpc-009470e55cc89e05e"
      subnet_ids = ["subnet-051b703b3e3db09a5", 
                    "subnet-08210e4584335dfda", 
                    "subnet-06fc373b96fc60783"
                    ]
    }
    tags = {
      "Created By"  = "Sumanth Mysore"
      "Description" = "EKS Cluster created for Bootcamp-71 deployment using Terraform"
    }
    endpoint_access = "public"
    addons = ["coredns", "kube-proxy", "vpc-cni"]
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
    name           = "bc-71-node"
    instance_types = ["t3.medium"]
    min_size       = 3
    max_size       = 3
    desired_size   = 3
  }
}