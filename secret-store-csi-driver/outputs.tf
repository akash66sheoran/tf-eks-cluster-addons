output "namespace" {
  value = var.namespace
}

output "service_account_name" {
  value = var.service_account_name
}

output "iam_role_arn" {
  value = aws_iam_role.secrets_store_csi_role.arn
}