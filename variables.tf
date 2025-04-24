# IMPORTANT: Add addon specific variables here
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

# ================ IRSA variables ================

variable "service_account_name_prefix" {
  type        = string
  description = "The k8s argo-workflows service account name prefix."
}

variable "server_irsa_role_create" {
  type        = bool
  description = "Whether to create IRSA role and annotate service account for the server"
}

variable "server_irsa_additional_policies" {
  type        = map(string)
  description = "Map of the additional policies to be attached to server role. Where key is arbitrary id and value is policy arn"
}

variable "controller_irsa_role_create" {
  type        = bool
  description = "Whether to create IRSA role and annotate service account for the controller"
}

variable "controller_irsa_additional_policies" {
  type        = map(string)
  description = "Map of the additional policies to be attached to controller role. Where key is arbitrary id and value is policy arn"
}
