
locals {
  cluster_name = aws_eks_cluster.main.name
  cluster_host = aws_eks_cluster.main.endpoint
  cluster_ca   = base64decode(
    aws_eks_cluster.main.certificate_authority[0].data
  )

  # Optional: for CI/CD or cross-account access
  eks_role_arn = var.eks_access_role_arn
}

provider "kubernetes" {
  host                   = local.cluster_host
  cluster_ca_certificate = local.cluster_ca

  exec = {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "/usr/local/bin/aws"

    args = local.eks_role_arn != "" ? [
      "eks", "get-token",
      "--cluster-name", local.cluster_name,
      "--role-arn", local.eks_role_arn
    ] : [
      "eks", "get-token",
      "--cluster-name", local.cluster_name
    ]
  }
}



provider "helm" {
  kubernetes = {
    host                   = local.cluster_host
    cluster_ca_certificate = local.cluster_ca

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "/usr/local/bin/aws"

      args = local.eks_role_arn != "" ? [
        "eks", "get-token",
        "--cluster-name", local.cluster_name,
        "--role-arn", local.eks_role_arn
      ] : [
        "eks", "get-token",
        "--cluster-name", local.cluster_name
      ]
    }
  }
}
