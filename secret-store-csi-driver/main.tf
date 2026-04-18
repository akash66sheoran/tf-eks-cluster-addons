resource "kubernetes_namespace" "this" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "secrets_store_csi_driver_aws" {
  name             = "secrets-store-csi-driver-provider-aws"
  repository       = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart            = "secrets-store-csi-driver-provider-aws"
  namespace        = var.namespace
  create_namespace = false

  # Pin a chart version after you confirm the one you want in your environment.
  # version = "x.y.z"

  values = [
    yamlencode({
      awsRegion = var.aws_region

      serviceAccount = {
        create = true
        name   = var.service_account_name
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.secrets_store_csi_role.arn
        }
      }

      secrets-store-csi-driver = {
        install = true
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.this,
    aws_iam_role_policy_attachment.attach
  ]
}