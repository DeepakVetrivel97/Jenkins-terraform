locals {
  cluster_name = data.terraform_remote_state.eks.outputs.eks_cluster_name
  endpoint     = data.terraform_remote_state.eks.outputs.eks_cluster_endpoint
  ca_data      = base64decode(data.terraform_remote_state.eks.outputs.eks_cluster_certificate_authority_data)
}

# Kubernetes Provider (Secure)
provider "kubernetes" {
  host                   = local.endpoint
  cluster_ca_certificate = local.ca_data

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"

    command = "aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      local.cluster_name
    ]
  }
}

# Helm Provider (Secure)
provider "helm" {
  kubernetes = {
    host                   = local.endpoint
    cluster_ca_certificate = local.ca_data

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"

      command = "aws"

      args = [
        "eks",
        "get-token",
        "--cluster-name",
        local.cluster_name
      ]
    }
  }
}
