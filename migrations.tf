moved {
  from = aws_iam_role.server[0]
  to = module.addon-irsa["argo-workflows-server"].aws_iam_role.this[0] 
}

moved {
  from = aws_iam_role_policy_attachment.server_additional["AllowArtifactsS3Bucket"]
  to = module.addon-irsa["argo-workflows-server"].aws_iam_role_policy_attachment.this_additional["AllowArtifactsS3Bucket"]
}

moved {
  from = aws_iam_role.controller[0]
  to = module.addon-irsa["argo-workflows-controller"].aws_iam_role.this[0] 
}

moved {
  from = aws_iam_role_policy_attachment.controller_additional["AllowArtifactsS3Bucket"]
  to = module.addon-irsa["argo-workflows-controller"].aws_iam_role_policy_attachment.this_additional["AllowArtifactsS3Bucket"]
}
moved {
  from = helm_release.argo_application[0]
  to = module.addon.helm_release.argo_application[0]
}
