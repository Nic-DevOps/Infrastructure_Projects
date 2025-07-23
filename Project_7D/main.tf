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


provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  # zone    = var.gcp_zone       
}

provider "azurerm" {
  features {} # keep defaults
  subscription_id = var.azure_subscription_id
  tenant_id       = var.azure_tenant_id
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
# GCP Networking – VPC + Subnet                                                   #
###############################################################################

# Reserve a small VPC network.
resource "google_compute_network" "vm_net" {
  name                    = "${local.common_tags.project}-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vm_subnet" {
  name          = "${local.common_tags.project}-subnet"
  ip_cidr_range = "10.20.1.0/24"
  network       = google_compute_network.vm_net.id
  region        = var.gcp_region
}

# Allow SSH ingress via firewall rule.
resource "google_compute_firewall" "vm_fw" {
  name    = "${local.common_tags.project}-allow-ssh"
  network = google_compute_network.vm_net.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${local.common_tags.project}-vm"]
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
  count  = var.deploy_gcp ? var.gcp_vm_count : 0
  instance_index = count.index
  gcp_region  = var.gcp_region
  ssh_pub_key = var.ssh_pub_key
  labels      = local.common_tags

  network_id   = google_compute_network.vm_net.id
  subnet_id    = google_compute_subnetwork.vm_subnet.id
  firewall_tag = "${local.common_tags.project}-vm"
}

module "azure_vm" {
  source         = "./modules/azure_vm"
  count          = var.deploy_azure ? 1 : 0
  admin_username = var.admin_username
  azure_region   = var.azure_region
  azure_vm_size  = var.azure_vm_size
  image          = var.image
  ssh_pub_key    = var.ssh_pub_key
  tags           = local.common_tags
}

###############################################################################
# Outputs                                                                     #
###############################################################################

output "aws_public_ip" {
  description = "Public IPv4 address of the AWS EC2 instance."
  value       = try(module.aws_vm[0].public_ip, null)
}

output "gcp_public_ip" {
  description = "Public IPv4 address of the GCP Compute Engine instance."
  value       = [for i in module.gcp_vm : i.public_ip]
}

output "azure_public_ip" {
  description = "Public IPv4 address of the Azure VM."
  value       = try(module.azure_vm[0].public_ip, null)
}