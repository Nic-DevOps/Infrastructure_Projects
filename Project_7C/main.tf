###############################################################################
# Project 7 – Multi‑Cloud VM Provisioner                                      #
#                                                                             #
# Root module: orchestrates provider setup and calls cloud‑specific modules.   #
###############################################################################

terraform {
  # Lock Terraform version for reproducibility.
  required_version = ">= 1.6"

  required_providers {
    aws   = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
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

# Google Cloud provider – authenticates via the GOOGLE_APPLICATION_CREDENTIALS   
# environment variable pointing to a JSON service‑account key.                  
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Azure provider – azurerm requires an Azure Service Principal or Azure CLI login.
provider "azurerm" {
  features {}
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
}

###############################################################################
# Local Values                                                                #
###############################################################################

locals {
  # Common metadata tags / labels applied to all resources, keeping naming     
  # consistent across clouds.                                                 
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
  source = "./modules/aws_vm"            # Path to AWS module
  count  = var.deploy_aws ? 1 : 0         # Conditional deployment

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

module "azure_vm" {
  source = "./modules/azure_vm"
  count  = var.deploy_azure ? 1 : 0

  azure_region = var.azure_region
  ssh_pub_key  = var.ssh_pub_key
  tags         = local.common_tags
}

###############################################################################
# Outputs                                                                     #
###############################################################################

output "aws_public_ip" {
  description = "Public IPv4 address of the AWS EC2 instance."
  value       = module.aws_vm[0].public_ip
  condition   = var.deploy_aws
}

output "gcp_public_ip" {
  description = "Public IPv4 address of the GCP Compute Engine instance."
  value       = module.gcp_vm[0].public_ip
  condition   = var.deploy_gcp
}

output "azure_public_ip" {
  description = "Public IPv4 address of the Azure VM."
  value       = module.azure_vm[0].public_ip
  condition   = var.deploy_azure
}