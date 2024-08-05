terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
  }
}

provider "aws" {
  alias  = "eks_workloads"
  region = local.region
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  default     = "kasten-demo"
  type        = string
}

variable "eks_cluster_version" {
  description = "The desired Kubernetes version for the EKS cluster"
  default     = "1.30"
  type        = string

}

variable "eks_vpc_id" {
  default     = "vpc-070ab5210725893b6"
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
}

variable "eks_subnet_ids" {
  default     = ["subnet-0ae5c9e0f2a36a4c4", "subnet-0b51a88b5fa506286"]
  description = "The list of subnet IDs where the EKS cluster will be deployed"
  type        = list(string)
}

variable "eks_cp_subnet_ids" {
  default     = ["subnet-0db20b14b9de38bd7", "subnet-090d581539214d28c"]
  description = "The list of subnet IDs where the EKS control plane will be deployed"
  type        = list(string)
}

variable "node_count" {
  default = 2
  type    = string

}


#Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name        = var.eks_cluster_name
  cluster_version     = var.eks_cluster_version
  authentication_mode = "API_AND_CONFIG_MAP"

  cluster_endpoint_public_access = true

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

    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id                     = var.eks_vpc_id
  subnet_ids                 = var.eks_subnet_ids
  control_plane_subnet_ids   = var.eks_cp_subnet_ids
  create_iam_role            = true
  create_kms_key             = true
  create_node_security_group = true


  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3a.medium"]
  }

  eks_managed_node_groups = {
    wawm-mng-grp = {
      disk_size    = 20
      min_size     = var.node_count
      max_size     = 2
      desired_size = 2

      instance_types = ["t3a.medium"]
      capacity_type  = "ON_DEMAND"
    }
  }
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = local.env
    Owner       = local.owner
    App         = local.app 

  }

  
}

  resource "null_resource" "kasten-pre-init" {
    
    provisioner "local-exec" {
    command = "sudo sh scripts/run.sh"
  
  }
}

  

output "cluster-id" {
  value = module.eks.cluster_id
}

output "cluster-name" {
  value = module.eks.cluster_name
}

output "cluster-arn" {
  value = module.eks.cluster_arn
}


