data "aws_eks_cluster" "demo-cluster" {
  name = "kasten-demo"
}

data "aws_eks_cluster_auth" "demo-cluster-auth" {
  name = data.aws_eks_cluster.demo-cluster.name
}


variable "kasten_repo" {
  default = "https://charts.kasten.io/"
  type    = string
}

variable "kasten_version" {
  default = "7.0.4"
  type    = string
}

variable "kasten_name" {
  default = "kasten-io"
  type    = string

}

variable "kasten_chart_ver" {
  default = "k10"
  type    = string
}

variable "region" {
  default = "ap-southeast-1a"
  type = string
}


resource "kubernetes_namespace" "kasten-ns" {
  metadata {
    name = "kasten-io"
  }

}



provider "kubernetes" {
  host                   = data.aws_eks_cluster.demo-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo-cluster.certificate_authority[0].data)
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.demo-cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo-cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.demo-cluster-auth.token
  }
}

resource "helm_release" "kasten" {
  name             = var.kasten_name
  repository       = var.kasten_repo
  chart            = var.kasten_chart_ver
  version          = var.kasten_version
  create_namespace = true
  namespace        = kubernetes_namespace.kasten-ns.id
  timeout          = 1800
  depends_on       = [kubernetes_namespace.kasten-ns ]

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "externalGateway.create"
    value = "true"
  }

  set {
    name  = "auth.tokenAuth.enabled"
    value = "true"
  }

  set {
    name  = "metering.mode"
    value = "airgap"
  }

  set {
    name = "global.persistence.enabled"
    value = "false"
  }

  set {
    name = "prometheus.server.enabled"
    value = "false"
  }

  set {
    name = "grafana.enabled"
    value = "false"
  }

  

}