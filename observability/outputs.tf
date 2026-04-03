output "namespace" {
  value = kubernetes_namespace.observability.metadata[0].name
}

output "storage_class_name" {
  value = kubernetes_storage_class_v1.gp3_observability.metadata[0].name
}

output "eck_operator_release" {
  value = helm_release.eck_operator.name
}

output "elasticsearch_release" {
  value = helm_release.elasticsearch.name
}

output "kibana_release" {
  value = helm_release.kibana.name
}

output "fluent_bit_release" {
  value = helm_release.fluent_bit.name
}