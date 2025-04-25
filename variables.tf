# IMPORTANT: Add addon specific variables here
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

# ================ IRSA variables ================

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

variable "controller_irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create IRSA role and annotate service account for the controller"
}

variable "controller_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to controller role. Where key is arbitrary id and value is policy arn"
}

variable "workflow_irsa_role_create" {
  type        = bool
  default     = false
  description = "Whether to create IRSA role and annotate service account for the workflow"
}

variable "workflow_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to workflow role. Where key is arbitrary id and value is policy arn"
}
