provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

provider "azurerm" {
  features {}

  # Uncomment if using service principal authentication
  # subscription_id = var.azure_subscription_id
  # client_id       = var.azure_client_id
  # client_secret   = var.azure_client_secret
  # tenant_id       = var.azure_tenant_id
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone

  # Uncomment if using service account key file
  # credentials = var.gcp_credentials_file
}
