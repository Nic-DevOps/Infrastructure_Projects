###############################################################################
# Root‑level variable declarations.                                            #
###############################################################################

# ───────── Deployment Toggles ─────────
variable "deploy_aws" {
  description = "Set to true to deploy resources on AWS."
  type        = bool
  default     = true
}

variable "deploy_gcp" {
  description = "Set to true to deploy resources on GCP."
  type        = bool
  default     = true
}

variable "deploy_azure" {
  description = "Set to true to deploy resources on Azure."
  type        = bool
  default     = true
}

# ───────── Common Metadata ─────────
variable "project_name" {
  description = "Logical project identifier applied as a tag/label."
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner or team responsible for the resources."
  type        = string
}

# ───────── Cloud‑specific Inputs ─────────
variable "aws_region" {
  description = "AWS region for EC2 instance (e.g., us‑west‑2)."
  type        = string
  default     = "us‑west‑2"
}

variable "gcp_region" {
  description = "GCP region for Compute Engine instance (e.g., us‑west1)."
  type        = string
  default     = "us‑west1"
}

variable "gcp_project_id" {
  description = "ID of your GCP project."
  type        = string
}

variable "azure_region" {
  description = "Azure region for the VM (e.g., eastus)."
  type        = string
  default     = "australiaeast"
}

variable "azure_subscription_id" {
  description = "Azure Subscription UUID."
  type        = string
  default     = null
}

variable "azure_tenant_id" {
  description = "Azure Tenant (AAD) UUID."
  type        = string
  default     = null
}

# ───────── SSH Key ─────────
variable "ssh_pub_key" {
  description = "Contents of your public SSH key (e.g., id_rsa.pub)."
  type        = string
}