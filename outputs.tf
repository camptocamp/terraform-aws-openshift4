output "kubeconfig" {
  value = data.aws_s3_bucket_object.kubeconfig.body
}
output "kubeadmin_password" {
  value = data.aws_s3_bucket_object.kubeadmin_password.body
}