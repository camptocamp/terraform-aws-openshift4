provider "aws" {
  region = var.region
}

locals {
  assets_dir = "${path.root}/${var.cluster_name}"
}

resource "aws_s3_bucket" "assets_bucket" {
  bucket        = format("%s.%s", var.cluster_name, var.base_domain)
  force_destroy = true
  lifecycle {
    ignore_changes = [object_lock_configuration]
  }
}

resource "aws_s3_bucket_object" "install_config" {
  bucket  = aws_s3_bucket.assets_bucket.bucket
  key     = "install-config.yaml"
  content = file(var.install_config_path)
  etag    = md5(var.install_config_path)
}
resource "local_file" "assetsadf_dir" {
  filename = "${local.assets_dir}/.shto"
}
resource "local_file" "assets_dir" {
  filename = "${local.assets_dir}/.witness"

  provisioner "local-exec" {
    command     = "cd $ASSETS_DIR && openshift-install --dir=. destroy cluster"
    when        = destroy
    environment = {
      ASSETS_DIR = dirname(self.filename)
    }
  }
}

resource "null_resource" "deploy_ocp" {

  provisioner "local-exec" {
    command     = var.sync_assets_bucket
    interpreter = var.wait_for_interpreter
    environment = {
      ASSETS_BUCKET = aws_s3_bucket.assets_bucket.bucket
      ASSETS_DIR    = local.assets_dir
      AWS_REGION    = var.region
     
    }
  }

  provisioner "local-exec" {
    command     = var.wait_for_create_cluster_cmd
    interpreter = var.wait_for_interpreter
    environment = {
      ASSETS_DIR = local.assets_dir
    }
  }

  provisioner "local-exec" {
    command     = var.sync_assets_to_bucket
    environment = {
      ASSETS_BUCKET = aws_s3_bucket.assets_bucket.bucket
      AWS_REGION = var.region
      ASSETS_DIR = local.assets_dir
    }
  }
}

data "aws_s3_bucket_object" "kubeconfig" {
  bucket = aws_s3_bucket.assets_bucket.bucket
  key    = "auth/kubeconfig"

  depends_on = [
    null_resource.deploy_ocp,
  ]
}

