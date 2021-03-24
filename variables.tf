variable "install_config_path" {
    description = "Path of the install-config.yaml"
    type        = string
}

variable "wait_for_create_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the installation of the openshift cluster is complete. Assets dir will be available as an environment variable called ASSETS_DIR"
  type        = string
  default     = "cd $ASSETS_DIR && openshift-install --dir=. create cluster"
}

variable "wait_for_destroy_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the installation of the openshift cluster is complete. Assets dir will be available as an environment variable called ASSETS_DIR"
  type        = string
  default     = "cd $ASSETS_DIR && openshift-install --dir=. destroy cluster"
}

variable "base_domain" {
  description = "The base domain used for Ingresses."
  type        = string
}

variable "region" {
  description = "The AWS region."
  type        = string
}

variable "cluster_name" {
  description = "The cluster name."
  type        = string
}

variable "wait_for_interpreter" {
  description = "Custom local-exec command line interpreter for the command to determining if the eks cluster is healthy."
  type        = list(string)
  default     = ["/bin/sh", "-c"]
}

variable "sync_assets_to_bucket" {
  description = "Sync assets from bucket local assets dir. Assets bucket will be available as an environment variable called ASSETS_BUCKET, assets dir as ASSETS_DIR, S3 endpoint as S3_ENDPOINT and AWS_REGION must be set."
  type        = string
  default     = "aws s3 sync $ASSETS_DIR s3://$ASSETS_BUCKET --content-type text/plain"
}

variable "sync_assets_bucket" {
  description = "Sync assets from bucket local assets dir. Assets bucket will be available as an environment variable called ASSETS_BUCKET, assets dir as ASSETS_DIR, S3 endpoint as S3_ENDPOINT and AWS_REGION must be set."
  type        = string
  default     = "aws s3 sync s3://$ASSETS_BUCKET $ASSETS_DIR --content-type text/plain"
}
