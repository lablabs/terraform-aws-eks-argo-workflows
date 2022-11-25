locals {
  values_default = yamlencode({
    server = {
      serviceAccount = {
        name = "${var.service_account_name_prefix}-server"
      }
    }
    controller = {
      serviceAccount = {
        name = "${var.service_account_name_prefix}-controller"
      }
    }
    workflow = {
      serviceAccount = {
        name = "${var.service_account_name_prefix}-workflow"
      }
    }
  })
}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    local.values_default,
    local.server_irsa_role_create ? yamlencode({
      server = {
        serviceAccount = {
          annotations = {
            "eks.amazonaws.com/role-arn" = aws_iam_role.server[0].arn
          }
        }
        podSecurityContext = {
          fsGroup = 65534
        }
      }
    }) : "",
    var.values,
  ])
}
