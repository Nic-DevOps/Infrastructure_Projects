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


# AWS
variable "aws_region" {
  description = "AWS region for EC2 instance (e.g., us‑west‑2)."
  type        = string
  default     = "us‑west‑2"
}


# GCP
variable "gcp_region" {
  description = "GCP region for Compute Engine instance (e.g., us‑west1)."
  type        = string
  default     = "us‑west1"
}

variable "gcp_project_id" {
  description = "ID of your GCP project."
  type        = string
}


#Azure

variable "azure_region" {
  description = "Azure region for the VM (e.g., eastus)."
  type        = string
  default     = "eastus2"
}

variable "image" {
  description = "Map describing the image to use"
  type        = map(string)
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

variable "azure_vm_size" {
  description = "VM SKU, e.g. Standard_B1s"
  type        = string
  default     = "Standard_B1s"
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

variable "admin_username" {
  description = "Linux admin user"
  type        = string
  default     = "ubuntu"
}

# ───────── SSH Key ─────────
variable "ssh_pub_key" {
  description = "Contents of your public SSH key (e.g., id_rsa.pub)."
  type        = string
}