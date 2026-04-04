locals {
  namespace          = var.namespace
  release_name       = var.release_name
  storage_class_name = var.storage_class_name
}

resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = local.namespace

    labels = {
      name = local.namespace
    }
  }
}

resource "kubernetes_storage_class_v1" "monitoring_ebs" {
  metadata {
    name = local.storage_class_name
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    type      = var.ebs_volume_type
    fsType    = var.fs_type
    encrypted = "true"
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name             = local.release_name
  namespace        = local.namespace
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = var.chart_version
  create_namespace = false

  timeout          = 900
  cleanup_on_fail  = true
  atomic           = true
  wait             = true

  values = [
    yamlencode({
      crds = {
        enabled = true
      }

      grafana = {
        enabled           = true
        defaultDashboardsEnabled = true

        adminUser     = var.grafana_admin_user
        adminPassword = var.grafana_admin_password

        persistence = {
          enabled          = true
          type             = "pvc"
          storageClassName = local.storage_class_name
          accessModes      = ["ReadWriteOnce"]
          size             = var.grafana_storage_size
          finalizers       = ["kubernetes.io/pvc-protection"]
        }

        service = {
          type = "ClusterIP"
          port = 80
        }

        resources = {
          requests = {
            cpu    = "100m"
            memory = "256Mi"
          }
          limits = {
            cpu    = "500m"
            memory = "512Mi"
          }
        }
      }

      prometheus = {
        enabled = true

        service = {
          type = "ClusterIP"
        }

        prometheusSpec = {
          retention     = var.prometheus_retention
          retentionSize = var.prometheus_retention_size

          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = local.storage_class_name
                accessModes      = ["ReadWriteOnce"]

                resources = {
                  requests = {
                    storage = var.prometheus_storage_size
                  }
                }
              }
            }
          }

          resources = {
            requests = {
              cpu    = "500m"
              memory = "2Gi"
            }
            limits = {
              cpu    = "1"
              memory = "4Gi"
            }
          }
        }
      }

      alertmanager = {
        enabled = true

        alertmanagerSpec = {
          storage = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = local.storage_class_name
                accessModes      = ["ReadWriteOnce"]

                resources = {
                  requests = {
                    storage = var.alertmanager_storage_size
                  }
                }
              }
            }
          }

          resources = {
            requests = {
              cpu    = "100m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "250m"
              memory = "512Mi"
            }
          }
        }
      }

      kube-state-metrics = {
        enabled = true
      }

      nodeExporter = {
        enabled = true
      }

      prometheusOperator = {
        enabled = true
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.monitoring,
    kubernetes_storage_class_v1.monitoring_ebs
  ]
}