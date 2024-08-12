resource "aws_ebs_volume" "kasten-data" {
  count = 5

  availability_zone = var.region
  size = 50
  type = "gp2"

  tags = {
    Name = local.pvc_names[count.index]
  }

}

locals {
  pvc_names = ["prometheus-server", "metering-pv-claim", "kasten-io-grafana", "jobs-pv-claim",  "catalog-pv-claim" ]
}

resource "kubernetes_persistent_volume" "kasten_pv" {
  count = 5
  metadata {
    
    name = local.pvc_names[count.index]
  }

  spec { 
    capacity = {
      storage = "10Gi"
    }

    access_modes = ["ReadWriteOnce"]


 persistent_volume_source {
      csi {
        driver       = "ebs.csi.aws.com"
        volume_handle = aws_ebs_volume.kasten-data[count.index].id
        fs_type       = "ext4"
      }
    }
  }
}

/*
resource "kubernetes_persistent_volume_claim" "kasten_pvc" {
  count = 5

  metadata {
    name      = local.pvc_names[count.index]
    namespace = kubernetes_namespace.kasten-ns.id
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }

    volume_name = local.pvc_names[count.index] 
  }
}
*/

