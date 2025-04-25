/**
 * # AWS EKS Argo Workflows Terraform module 
 *
 * A Terraform module to deploy the Argo Workflows on Amazon EKS cluster.
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
      service_account_name_prefix = "argo-workflows"
      irsa_role_create = var.server_irsa_role_create != null ? var.server_irsa_role_create : true
      irsa_assume_role_policy_condition_values =  "system:serviceaccount:${var.namespace}:${var.service_account_name_prefix}-server"
      irsa_role_name_prefix = "argo-workflows-irsa"
      irsa_additional_policies = var.server_irsa_additional_policies ? var.server_irsa_additional_policies : tomap({})
    }
    "${local.addon.name}-controller" = {
      service_account_name_prefix = "argo-workflows"
      irsa_role_create = var.controller_irsa_role_create != null ? var.controller_irsa_role_create : true
      irsa_assume_role_policy_condition_values =  "system:serviceaccount:${var.namespace}:${var.service_account_name_prefix}-controller"
      irsa_role_name_prefix = "argo-workflows-irsa"
      irsa_additional_policies = var.controller_irsa_additional_policies ? var.controller_irsa_additional_policies : tomap({})
    }
   
    # TODO: Maybe we should replace service_account_name_prefix to service_account_name which is more supported by universal module
  }

  addon_values = yamlencode({
    # FIXME config: add default values here
    server = module.addon-irsa["${local.addon.name}-server"].irsa_role_enabled ? {
      serviceAccount = { 
        name = "${local.addon_irsa[local.addon.name].service_account_name_prefix}-server"
        annotations = module.addon-irsa["${local.addon.name}-server"].irsa_role_enabled ? {
	  "eks.amazonaws.com/role-arn" = module.addon-irsa["${local.addon.name}-server"].iam_role_attributes.arn 
        } : tomap({})
      }
      podSecurityContext = local.addon_irsa[local.addon.name].server_irsa_role_create ? { 
        fsGroup = 65534 
      } : tomap({})
    } : {
      serviceAccount = {
        name = "${local.addon_irsa[local.addon.name].service_account_name_prefix}-server"
        annotations = {}   # Must be here, due to TF inconsistency on true/false side of statement
      }
      podSecurityContext = tomap({})
    } 

    controller = {
      serviceAccount = module.addon-irsa["${local.addon.name}-controller"].irsa_role_enabled ? {
        name = "${local.addon_irsa[local.addon.name].service_account_name_prefix}-controller"
        annotations = local.addon_irsa[local.addon.name].controller_irsa_role_create ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["${local.addon.name}-controller"].iam_role_attributes.arn 
        } : tomap({})
      } : {
        name = "${local.addon_irsa[local.addon.name].service_account_name_prefix}-controller"
        annotations = {}   # Must be here, due to TF inconsistency on true/false side of statement
      }
    }

    workflow = {
      serviceAccount = {
        name = "${local.addon_irsa[local.addon_name].service_account_name_prefix}-workflow"
      }
    }
  })
}
