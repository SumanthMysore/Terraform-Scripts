output "eks_ca" {
  value = module.eks.cluster_certificate_authority_data
}

output "eks_ce" {
  value = module.eks.cluster_endpoint
}

output "eks_token" {
  sensitive = true
  value     = data.aws_eks_cluster_auth.for_token.token
}