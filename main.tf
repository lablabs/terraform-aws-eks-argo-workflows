/**
 * # AWS EKS Universal Addon Terraform module
 *
 * A Terraform module to deploy the universal addon on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/pre-commit.yaml)
 */
# FIXME config: update addon docs above
locals {
  # FIXME config: add addon configuration here
  addon = {
    #TODO: check with odstrk, should be changed to helm_enabled
    enabled = true
    name = "argo-workflows"  # used as defaults for argo_name, helm_chart_name, helm_release_name
    namespace = "argo-workflows"       # used as defaults for argo_namespace 

    helm_chart_version = "0.20.8"
    helm_repo_url      = "https://argoproj.github.io/argo-helm"

    argo_namespace = "argo"    
    argo_kubernetes_manifest_computed_fields = ["metadata.labels", "metadata.annotations"]

  }

  # FIXME config: add addon IRSA configuration here or remove if not needed
  addon_irsa = {
    (local.addon.name) = {
      # FIXME config: add default IRSA overrides here or leave empty if not needed, but make sure to keep at least one key
      service_account_name_prefix = "argo-workflows"
      irsa_role_name_prefix = "argo-workflows-irsa"
      server_irsa_role_create = true
      controller_irsa_role_create = true
    }
  }

  # FIXME config: add addon OIDC configuration here or remove if not needed
  addon_oidc = {
    (local.addon.name) = {
      # FIXME config: add default OIDC overrides here or leave empty if not needed, but make sure to keep at least one key
    }
  }

  addon_values = yamlencode({
    # FIXME config: add default values here
    server = module.addon-irsa[local.addon_name].irsa_role_enabled ? {
      serviceAccount = 
        name = "${local.addon-irsa[local.addon_name].service_account_name_prefix}-server"
        annotations = local.addon-irsa[local.addon_name].server_irsa_role_create ? {"eks.amazonaws.com/role-arn" = aws_iam_role.controller[0].arn} : {}
      }
      podSecurityContext = local.addon-irsa[local.addon_name].server_irsa_role_create ? { fsGroup = 65534 } : {}
    } : {
      serviceAccount = {
        name = "${local.addon-irsa[local.addon_name].service_account_name_prefix}-server"
      }
    } 
    controller = {
      serviceAccount = module.addon-irsa[local.addon_name].irsa_role_enabled ? {
        name = "${local.addon-irsa[local.addon_name].service_account_name_prefix}-controller"
        annotations = local.addon-irsa[local.addon_name].controller_irsa_role_create ? {"eks.amazonaws.com/role-arn" = aws_iam_role.controller[0].arn} : {}
      } : {
        name = "${local.addon-irsa[local.addon_name].service_account_name_prefix}-controller"
      }
    }
    workflow = {
      serviceAccount = {
        name = "${local.addon-irsa[local.addon_name].service_account_name_prefix}-workflow"
      }
    }
  })
}
