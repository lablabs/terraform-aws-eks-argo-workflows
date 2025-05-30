moved {
  from = kubernetes_manifest.this
  to   = module.addon.kubernetes_manifest.this
}

moved {
  from = helm_release.this
  to   = module.addon.helm_release.this
}

moved {
  from = helm_release.argo_application
  to   = module.addon.helm_release.argo_application
}

moved {
  from = aws_iam_role.server
  to   = module.addon-irsa["server"].aws_iam_role.this
}

moved {
  from = aws_iam_role_policy_attachment.server_additional
  to   = module.addon-irsa["server"].aws_iam_role_policy_attachment.this_additional
}

moved {
  from = aws_iam_role.controller
  to   = module.addon-irsa["controller"].aws_iam_role.this
}

moved {
  from = aws_iam_role_policy_attachment.controller_additional
  to   = module.addon-irsa["controller"].aws_iam_role_policy_attachment.this_additional
}

moved {
  from = aws_iam_role.workflow
  to   = module.addon-irsa["workflow"].aws_iam_role.this
}

moved {
  from = aws_iam_role_policy_attachment.workflow_additional
  to   = module.addon-irsa["workflow"].aws_iam_role_policy_attachment.this_additional
}
