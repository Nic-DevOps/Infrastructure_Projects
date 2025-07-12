provider "aws" {
  region     = var.aws_region
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone        = var.gcp_zone
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}

