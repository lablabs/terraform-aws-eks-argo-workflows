/**
 * # AWS EKS Argo Workflows Terraform module 
 *
 * A Terraform module to deploy the [Argo Workflows](https://argoproj.github.io/workflows/) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-argo-workflows/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-argo-workflows/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-argo-workflows/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-argo-workflows/actions/workflows/pre-commit.yml)
 */

locals {
  addon = {
    name = "argo-workflows" 
    namespace = "argo-workflows" 

    helm_chart_version = "0.20.8"
    helm_repo_url      = "https://argoproj.github.io/argo-helm"
  }

  addon_irsa = {
    "${local.addon.name}-server" = {
      service_account_name = "${local.addon.name}-server"
      irsa_role_create = var.server_irsa_role_create != null ? var.server_irsa_role_create : true
      irsa_role_name = "${local.addon.name}-serv-irsa" # Max length of rolename was reached, using shortened version
      irsa_additional_policies = var.server_irsa_additional_policies != {} ? var.server_irsa_additional_policies : tomap({})
    }
    "${local.addon.name}-controller" = {
      service_account_name = "${local.addon.name}-controller"
      irsa_role_create = var.controller_irsa_role_create != null ? var.controller_irsa_role_create : true
      irsa_role_name= "${local.addon.name}-ctrl-irsa" # Max length of rolename was reached, using shortened version
      irsa_additional_policies = var.controller_irsa_additional_policies != {} ? var.controller_irsa_additional_policies : tomap({})
    }
     "${local.addon.name}-workflow" = {
      service_account_name = "${local.addon.name}-workflow"
      irsa_role_create = var.workflow_irsa_role_create != null ? var.workflow_irsa_role_create : false
      irsa_role_name= "${local.addon.name}-work-irsa" # Max length of rolename was reached, using shortened version
      irsa_additional_policies = var.workflow_irsa_additional_policies != {} ? var.controller_irsa_additional_policies : tomap({})
    }
  }

  addon_values = yamlencode({
    # FIXME config: add default values here
    server = {
      serviceAccount = { 
        name = local.addon_irsa["${local.addon.name}-server"].service_account_name
        annotations = module.addon-irsa["${local.addon.name}-server"].irsa_role_enabled ? {
	  "eks.amazonaws.com/role-arn" = module.addon-irsa["${local.addon.name}-server"].iam_role_attributes.arn 
        } : tomap({})
      }
      podSecurityContext = module.addon-irsa["${local.addon.name}-server"].irsa_role_enabled ? { 
        fsGroup = 65534 
      } : tomap({})
    } 

    controller = {
      serviceAccount = {
        name = local.addon_irsa["${local.addon.name}-controller"].service_account_name
        annotations = module.addon-irsa["${local.addon.name}-controller"].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["${local.addon.name}-controller"].iam_role_attributes.arn 
        } : tomap({})
      }
    }

    workflow = {
      serviceAccount = {
        name = local.addon_irsa["${local.addon.name}-workflow"].service_account_name 
        annotations = module.addon-irsa["${local.addon.name}-workflow"].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["${local.addon.name}-workflow"].iam_role_attributes.arn 
        } : tomap({})
      }

    }
  })
}
