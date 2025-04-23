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
    name = "argo-workflows"  # used for argo_name, helm_chart_name, helm_release_name defaults
    namespace = "argo"       # used for argo_namespace 

    helm_chart_version = "0.20.8"
    helm_repo_url      = "https://argoproj.github.io/argo-helm"
    namespace = "argo-workflows"

    argo_enabled = false
    argo_helm_enabled = false
    
  }

  # FIXME config: add addon IRSA configuration here or remove if not needed
  addon_irsa = {
    (local.addon.name) = {
      # FIXME config: add default IRSA overrides here or leave empty if not needed, but make sure to keep at least one key
      service_account_name_prefix = "argo-workflows"
      irsa_role_name_prefix = "argo-workflows-irsa"
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
    argo_namespace = "argo"
    argo_enabled = false
    argo_helm_enabled = false
    argo_destination_server = "https://kubernetes.default.svc"
    argo_project = "default"
    argo_info = [{
    "name"  = "terraform"
    "value" = "true"
    }]
    argo_metadata = {
    "finalizers" : [
      "resources-finalizer.argocd.argoproj.io"
      ]
    }

  })
}
