# IMPORTANT: Add addon specific variables here
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

# ================ IRSA variables ================

variable "server_rbac_create" {
  type        = bool
  default     = true
  description = "Whether to create and use Server RBAC resources."
  nullable    = false
}

variable "server_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create the Service Account for the Server."
  nullable    = false
}

variable "server_service_account_name" {
  type        = string
  default     = "argo-workflows-server"
  description = "The name of the Service Account for the Server."
  nullable    = false
}

variable "server_irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create IRSA role and annotate service account for the Server."
  nullable    = false
}

variable "server_irsa_role_name" {
  type        = string
  default     = "argo-workflows-server"
  description = "The name of the IRSA role for the Server."
  nullable    = false
}

variable "server_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to server role. Where key is arbitrary id and value is policy arn"
  nullable    = false
}

variable "controller_rbac_create" {
  type        = bool
  default     = true
  description = "Whether to create and use Controller RBAC resources."
  nullable    = false
}

variable "controller_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create the Service Account for the Controller."
  nullable    = false
}

variable "controller_service_account_name" {
  type        = string
  default     = "argo-workflows-controller"
  description = "The name of the Service Account for the Controller."
  nullable    = false
}

variable "controller_irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create IRSA role and annotate service account for the Controller."
  nullable    = false
}

variable "controller_irsa_role_name" {
  type        = string
  default     = "argo-workflows-controller"
  description = "The name of the IRSA role for the Controller."
  nullable    = false
}

variable "controller_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to controller role. Where key is arbitrary id and value is policy arn"
  nullable    = false
}

variable "workflow_rbac_create" {
  type        = bool
  default     = true
  description = "Whether to create and use Workflow RBAC resources."
  nullable    = false
}

variable "workflow_service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create the Service Account for the Workflow."
  nullable    = false
}

variable "workflow_service_account_name" {
  type        = string
  default     = "argo-workflows-workflow"
  description = "The name of the Service Account for the Workflow."
  nullable    = false
}

variable "workflow_irsa_role_create" {
  type        = bool
  default     = false
  description = "Whether to create IRSA role and annotate service account for the Workflow."
  nullable    = false
}

variable "workflow_irsa_role_name" {
  type        = string
  default     = "argo-workflows-workflow"
  description = "The name of the IRSA role for the Workflow."
  nullable    = false
}

variable "workflow_irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to workflow role. Where key is arbitrary id and value is policy arn"
  nullable    = false
}
