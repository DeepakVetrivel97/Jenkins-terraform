
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.main.name
}


provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "/usr/local/bin/aws"

    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}
resource "kubectl_manifest" "aws_auth" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system

data:
  mapRoles: |
    - rolearn: arn:aws:iam::948982764895:role/retail-dev-eks-nodegroup-role
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes

    - rolearn: arn:aws:iam::948982764895:role/jenkins-terraform-role
      username: jenkins
      groups:
        - system:masters
YAML
}
