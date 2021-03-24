output "kubeconfig" {
  value = data.aws_s3_bucket_object.kubeconfig.body
}