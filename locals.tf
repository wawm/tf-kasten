locals {
  region      = "ap-southeast-1"
  app         = "Kasten"
  env         = "Demo"
  owner       = "WAWM"
  cluster-arn = module.eks.cluster_arn
  profile     = "wawmio"

}