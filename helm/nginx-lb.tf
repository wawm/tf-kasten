data "aws_eks_cluster" "demo-cluster" {
  name = "eks-demo"
}

data "aws_eks_cluster_auth" "demo-cluster-auth" {
  name = data.aws_eks_cluster.demo-cluster.name
}



provider "kubernetes" {
  host                   = data.aws_eks_cluster.demo-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.demo-cluster.certificate_authority[0].data)
}



# Data source to get the EKS worker node instance IDs
data "aws_instance" "eks_instances" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = ["data."]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# Register EKS Instances with Target Group
resource "aws_lb_target_group_attachment" "example" {
  count            = length(data.aws_instance.eks_instances.ids)
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = data.aws_instance.eks_instances.ids[count.index]
  port             = 80