resource "kubernetes_namespace" "observability" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_storage_class_v1" "gp3_observability" {
  metadata {
    name = var.storage_class_name
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "false"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    type      = "gp3"
    fsType    = "ext4"
    encrypted = "true"
  }
}

resource "helm_release" "eck_operator" {
  name             = "elastic-operator"
  namespace        = kubernetes_namespace.observability.metadata[0].name
  repository       = "https://helm.elastic.co"
  chart            = "eck-operator"
  create_namespace = false

  timeout         = 900
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  depends_on = [
    kubernetes_namespace.observability
  ]
}

resource "helm_release" "elasticsearch" {
  name             = "elasticsearch"
  namespace        = kubernetes_namespace.observability.metadata[0].name
  repository       = "https://helm.elastic.co"
  chart            = "eck-elasticsearch"
  create_namespace = false

  timeout         = 1200
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  values = [
    file("${path.module}/elasticsearch-values.yaml")
  ]

  depends_on = [
    helm_release.eck_operator,
    kubernetes_storage_class_v1.gp3_observability
  ]
}

resource "helm_release" "kibana" {
  name             = "kibana"
  namespace        = kubernetes_namespace.observability.metadata[0].name
  repository       = "https://helm.elastic.co"
  chart            = "eck-kibana"
  create_namespace = false

  timeout         = 900
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  values = [
    file("${path.module}/kibana-values.yaml")
  ]

  depends_on = [
    helm_release.elasticsearch
  ]
}

resource "helm_release" "fluent_bit" {
  name             = "fluent-bit"
  namespace        = kubernetes_namespace.observability.metadata[0].name
  repository       = "oci://ghcr.io/fluent/helm-charts"
  chart            = "fluent-bit"
  create_namespace = false

  timeout         = 900
  wait            = true
  atomic          = true
  cleanup_on_fail = true

  values = [
    file("${path.module}/fluent-bit-values.yaml")
  ]

  depends_on = [
    helm_release.elasticsearch
  ]
}