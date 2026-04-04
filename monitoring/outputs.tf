output "monitoring_namespace" {
  value = kubernetes_namespace_v1.monitoring.metadata[0].name
}

output "monitoring_storage_class" {
  value = kubernetes_storage_class_v1.monitoring_ebs.metadata[0].name
}

output "helm_release_name" {
  value = helm_release.kube_prometheus_stack.name
}