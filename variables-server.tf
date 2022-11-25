# ================ IRSA variables (optional) ================

variable "server_irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create IRSA role and annotate service account for the server"
}

variable "server_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to server role. Where key is arbitrary id and value is policy arn"
}
