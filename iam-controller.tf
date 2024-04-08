locals {
  controller_irsa_role_create = var.enabled && var.controller_irsa_role_create
}

data "aws_iam_policy_document" "controller_irsa" {
  count = local.controller_irsa_role_create ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.namespace}:${var.service_account_name_prefix}-controller",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "controller" {
  count              = local.controller_irsa_role_create ? 1 : 0
  name               = "${var.irsa_role_name_prefix}-${var.helm_release_name}-controller"
  assume_role_policy = data.aws_iam_policy_document.controller_irsa[0].json
  tags               = var.irsa_tags
}

resource "aws_iam_role_policy_attachment" "controller_additional" {
  for_each = local.controller_irsa_role_create ? var.controller_irsa_additional_policies : {}

  role       = aws_iam_role.controller[0].name
  policy_arn = each.value
}
