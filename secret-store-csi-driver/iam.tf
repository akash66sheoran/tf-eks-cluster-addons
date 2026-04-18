locals {
  oidc_issuer_without_scheme = replace(data.aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://", "")
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.this.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_without_scheme}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_issuer_without_scheme}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "secrets_store_csi_role" {
  name               = "${var.cluster_name}-secrets-store-csi-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "secrets_access" {
  statement {
    sid    = "ReadSecretsManagerSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = var.secret_arns
  }
}

resource "aws_iam_policy" "secrets_access" {
  name   = "${var.cluster_name}-secrets-store-csi-secrets-access"
  policy = data.aws_iam_policy_document.secrets_access.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.secrets_store_csi_role.name
  policy_arn = aws_iam_policy.secrets_access.arn
}