terraform {
  backend "s3" {
    bucket         = "kasten-tf"
    key            = "eks-kasten/kasten-demo.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "wawm-tf-tbl"
    encrypt        = true
  }
}