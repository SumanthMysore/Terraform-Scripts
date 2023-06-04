module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.10.0"

  cluster_name    = var.cluster.name
  cluster_version = var.cluster.kubernetes_version

  vpc_id                          = var.cluster.vpc.vpc_id
  subnet_ids                      = var.cluster.vpc.subnet_ids
  cluster_endpoint_public_access  = (var.cluster.endpoint_access == "public") ? true : false
  cluster_endpoint_private_access = false

  tags = {
    "Created By"  = lookup(var.cluster.tags, "Created By")
    "owner"       = lookup(var.cluster.tags, "owner")
    "description" = lookup(var.cluster.tags, "description")
  }

  create_kms_key            = false
  cluster_encryption_config = {}

  create_cloudwatch_log_group = false
  cluster_enabled_log_types   = []

  create_iam_role = false
  iam_role_arn    = data.aws_iam_role.cluster_iam_role.arn

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  eks_managed_node_group_defaults = {
    ami_type      = var.node_groups_defaults["ami_type"]
    capacity_type = var.node_groups_defaults["capacity_type"]
  }

  eks_managed_node_groups = {
    one = {
      name           = var.node_group.name
      instance_types = var.node_group.instance_types
      min_size       = var.node_group.min_size
      max_size       = var.node_group.max_size
      desired_size   = var.node_group.desired_size
    }
  }
}

data "aws_iam_role" "cluster_iam_role" {
  name = "eks-cluster"
}

data "kubectl_file_documents" "docs" {
  content = templatefile("${path.module}/ingress-nginx-controller.yml", {
    acm_cert_arn = var.ingress-nginx-controller.acm_cert_arn
  })
}

resource "kubectl_manifest" "test" {
  for_each  = data.kubectl_file_documents.docs.manifests
  yaml_body = each.value
  depends_on = [
    module.eks
  ]
}

data "aws_eks_cluster_auth" "for_token" {
  name = module.eks.cluster_name
}
