/**
 * # AWS EKS Argo Workflows Terraform module
 *
 * A Terraform module to deploy the [Argo Workflows](https://argoproj.github.io/workflows/) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-argo-workflows/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-argo-workflows/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-argo-workflows/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-argo-workflows/actions/workflows/pre-commit.yaml)
 */
locals {
  addon = {
    name      = "argo-workflows"
    namespace = "argo-workflows"

    helm_chart_version = "0.20.8"
    helm_repo_url      = "https://argoproj.github.io/argo-helm"
  }

  addon_irsa = {
    server = {
      rbac_create              = var.server_rbac_create
      service_account_create   = var.server_service_account_create
      service_account_name     = var.server_service_account_name
      irsa_role_create         = var.server_irsa_role_create
      irsa_role_name           = var.server_irsa_role_name
      irsa_additional_policies = var.server_irsa_additional_policies
    }
    controller = {
      rbac_create              = var.controller_rbac_create
      service_account_create   = var.controller_service_account_create
      service_account_name     = var.controller_service_account_name
      irsa_role_create         = var.controller_irsa_role_create
      irsa_role_name           = var.controller_irsa_role_name
      irsa_additional_policies = var.controller_irsa_additional_policies
    }
    workflow = {
      rbac_create              = var.workflow_rbac_create
      service_account_create   = var.workflow_service_account_create
      service_account_name     = var.workflow_service_account_name
      irsa_role_create         = var.workflow_irsa_role_create
      irsa_role_name           = var.workflow_irsa_role_name
      irsa_additional_policies = var.workflow_irsa_additional_policies
    }
  }

  addon_values = yamlencode({
    server = {
      rbac = {
        create = module.addon-irsa["server"].rbac_create
      }

      serviceAccount = {
        create = module.addon-irsa["server"].service_account_create
        name   = module.addon-irsa["server"].service_account_name
        annotations = module.addon-irsa["server"].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["server"].iam_role_attributes.arn
        } : tomap({})
      }
      podSecurityContext = module.addon-irsa["server"].irsa_role_enabled ? {
        fsGroup = 65534
      } : tomap({})
    }

    controller = {
      rbac = {
        create = module.addon-irsa["controller"].rbac_create
      }

      serviceAccount = {
        create = module.addon-irsa["controller"].service_account_create
        name   = module.addon-irsa["controller"].service_account_name
        annotations = module.addon-irsa["controller"].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["controller"].iam_role_attributes.arn
        } : tomap({})
      }
    }

    workflow = {
      rbac = {
        create = module.addon-irsa["workflow"].rbac_create
      }

      serviceAccount = {
        create = module.addon-irsa["workflow"].service_account_create
        name   = module.addon-irsa["workflow"].service_account_name
        annotations = module.addon-irsa["workflow"].irsa_role_enabled ? {
          "eks.amazonaws.com/role-arn" = module.addon-irsa["workflow"].iam_role_attributes.arn
        } : tomap({})
      }

    }
  })

  addon_depends_on = []
}
