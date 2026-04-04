variable "cluster_name" {
  type = string
}

variable "aws_region" {
  type = string
  default = "ap-south-1"
}

variable "namespace" {
  description = "Namespace for monitoring stack"
  type        = string
  default     = "monitoring"
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "monitoring"
}

variable "chart_version" {
  description = "kube-prometheus-stack chart version"
  type        = string
  default     = "69.8.2"
}

variable "storage_class_name" {
  description = "StorageClass name for EBS-backed PVCs"
  type        = string
  default     = "monitoring-ebs-gp3"
}

variable "ebs_volume_type" {
  description = "EBS volume type"
  type        = string
  default     = "gp3"
}

variable "fs_type" {
  description = "Filesystem type for EBS volumes"
  type        = string
  default     = "ext4"
}

variable "prometheus_storage_size" {
  description = "Prometheus PVC size"
  type        = string
  default     = "30Gi"
}

variable "prometheus_retention" {
  description = "Prometheus data retention period"
  type        = string
  default     = "15d"
}

variable "prometheus_retention_size" {
  description = "Prometheus max retained data size"
  type        = string
  default     = "25GiB"
}

variable "grafana_storage_size" {
  description = "Grafana PVC size"
  type        = string
  default     = "10Gi"
}

variable "alertmanager_storage_size" {
  description = "Alertmanager PVC size"
  type        = string
  default     = "10Gi"
}

variable "grafana_admin_user" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "grafana_admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}