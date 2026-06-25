
##############################################
# ✅ EKS Cluster Locals
##############################################

locals {
  cluster_name = aws_eks_cluster.main.name
  cluster_host = aws_eks_cluster.main.endpoint
  cluster_ca   = base64decode(
    aws_eks_cluster.main.certificate_authority[0].data
  )
}

##############################################
# ✅ EKS Auth (NO CLI, NO exec)
##############################################

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_name
}

##############################################
# ✅ Kubernetes Provider (FIXED)
##############################################

provider "kubernetes" {
  host                   = local.cluster_host
  cluster_ca_certificate = local.cluster_ca
  token                  = data.aws_eks_cluster_auth.cluster.token
}

##############################################
# ✅ Helm Provider (FIXED)
##############################################

provider "helm" {
  kubernetes = {
    host                   = local.cluster_host
    cluster_ca_certificate = local.cluster_ca
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}
