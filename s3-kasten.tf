variable "kasten-storage" {
  default = "kasten-storage"
  type    = string
}


resource "aws_s3_bucket" "kasten-storage" {
  bucket = var.kasten-storage

  tags = {
    Name        = var.kasten-storage
    Environment = local.env
    App         = local.app
    Owner       = local.owner
  }
}


output "kasten-storage" {
  value = aws_s3_bucket.kasten-storage.id
}