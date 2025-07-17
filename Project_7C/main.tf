###############################################################################
# Project 7 – Multi‑Cloud VM Provisioner                                      #
#                                                                             #
# Root module: orchestrates provider setup and calls cloud‑specific modules.   #
###############################################################################

terraform {
  # Lock Terraform version for reproducibility.
  required_version = ">= 1.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

###############################################################################
# Provider Configuration                                                      #
###############################################################################

# AWS provider – uses environment variables AWS_ACCESS_KEY_ID / AWS_SECRET_ACCESS_KEY.
provider "aws" {
  region = var.aws_region
  # profile, assume_role, etc. can be added here.
}


provider "google" {
  project = var.gcp_project_id # e.g. "my‑tf‑lab‑123456"
  region  = var.gcp_region     # e.g. "us‑central1"
  # zone    = var.gcp_zone       # e.g. "us‑central1‑a"
}


###############################################################################
# Local Values                                                                #
###############################################################################

locals {
  # Common metadata tags / labels applied to all resources, keeping naming     
  # consistent across clouds.   
  # Locals are read-only variables computed at plan-time. Here you keep one source of 
  # truth for tags/labels so every resource in every provider stays in sync. 
  # If you add another common value (e.g. cost_center), put it here and all modules 
  # receive it automatically.                                              

  common_tags = {
    project     = var.project_name
    environment = var.environment
    owner       = var.owner
  }
}

###############################################################################
# Module Calls                                                                #
###############################################################################

module "aws_vm" {
  source = "./modules/aws_vm"     # Path to AWS module
  count  = var.deploy_aws ? 1 : 0 # Conditional deployment

  # Pass‑through variables
  aws_region  = var.aws_region
  ssh_pub_key = var.ssh_pub_key
  tags        = local.common_tags
}

module "gcp_vm" {
  source = "./modules/gcp_vm"
  count  = var.deploy_gcp ? 1 : 0

  gcp_region  = var.gcp_region
  ssh_pub_key = var.ssh_pub_key
  labels      = local.common_tags
}

# module "azure_vm" {
#  source = "./modules/azure_vm"
#  count  = var.deploy_azure ? 1 : 0

#  azure_region = var.azure_region
#  ssh_pub_key  = var.ssh_pub_key
#  tags         = local.common_tags
# }

###############################################################################
# Outputs                                                                     #
###############################################################################

output "aws_public_ip" {
  description = "Public IPv4 address of the AWS EC2 instance."
  value       = try(module.aws_vm[0].public_ip, null)
}

output "gcp_public_ip" {
  description = "Public IPv4 address of the GCP Compute Engine instance."
  value       = try(module.gcp_vm[0].public_ip, null)
}

# output "azure_public_ip" {
#  description = "Public IPv4 address of the Azure VM."
#  value       = try(module.azure_vm[0].public_ip, null)
# }