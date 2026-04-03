variable "namespace" {
  description = "Namespace for observability components"
  type        = string
  default     = "observability"
}

variable "storage_class_name" {
  description = "StorageClass used by Elasticsearch PVCs"
  type        = string
  default     = "gp3-observability"
}

variable "cluster_name" {
  type = string
}

variable "aws_region" {
  type = string
  default = "ap-south-1"
}