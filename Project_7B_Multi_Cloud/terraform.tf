# =============================================================================
# terraform.tf - Backend and Provider Configuration
# =============================================================================

terraform {
  required_version = ">= 1.0"
  
  # Configure remote backend (uncomment and configure as needed)
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "multi-cloud-vm/terraform.tfstate"
  #   region         = "us-west-2"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}