# Create a Kubernetes namespace
resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = "nginx-ingress"
  }
}

# Add the Nginx Ingress Controller Helm repository
resource "helm_repository" "nginx_ingress" {
  name  = "nginx-stable"
  url   = "https://helm.nginx.com/stable"
  type  = "OCI"
}

# Install the Nginx Ingress Controller Helm chart
resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = kubernetes_namespace.nginx_ingress.metadata[0].name
  repository = helm_repository.nginx_ingress.metadata[0].name
  chart      = "nginx-ingress"
  version    = "0.28.0"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.service.annotations.service\.beta\.kubernetes\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "controller.service.annotations.service\.beta\.kubernetes\.io/aws-load-balancer-ssl-cert"
    value = "arn:aws:acm:us-west-2:123456789012:certificate/abcdef12-3456-7890-abcd-ef1234567890"
  }

  set {
    name  = "controller.service.annotations.service\.beta\.kubernetes\.io/aws-load-balancer-backend-protocol"
    value = "http"
  }

  set {
    name  = "controller.stats.enabled"
    value = "true"
  }

  set {
    name  = "controller.stats.service.annotations.service\.beta\.kubernetes\.io/aws-load-balancer-type"
    value = "nlb"
  }

  set {
    name  = "controller.stats.service.annotations.service\.beta\.kubernetes\.io/aws-load-balancer-internal"
    value = "true"
  }
}