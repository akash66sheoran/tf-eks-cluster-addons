variable "cluster_name" {
  type = string
}

variable "aws_region" {
  type = string
  default = "ap-south-1"
}

variable "namespace" {
  description = "Namespace for Secrets Store CSI Driver"
  type        = string
  default     = "kube-system"
}

variable "service_account_name" {
  description = "Service account used by AWS provider"
  type        = string
  default     = "secrets-provider-aws"
}

variable "secret_arns" {
  description = "List of Secrets Manager secret ARNs the provider/pods can read"
  type        = list(string)
}