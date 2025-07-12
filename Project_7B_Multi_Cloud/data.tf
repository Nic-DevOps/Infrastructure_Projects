data "aws_caller_identity" "current" {
  count = var.deploy_aws ? 1 : 0
}

data "azurerm_client_config" "current" {
  count = var.deploy_azure ? 1 : 0
}

data "google_project" "current" {
  count = var.deploy_gcp ? 1 : 0
}
