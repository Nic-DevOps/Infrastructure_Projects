module "aws_vm" {
  source      = "./modules/aws_vm"
  instance_count = var.aws_instance_count
  region      = var.aws_region
}

module "gcp_vm" {
  source      = "./modules/gcp_vm"
  instance_count = var.gcp_instance_count
  region      = var.gcp_region
  project     = var.gcp_project
}

module "azure_vm" {
  source      = "./modules/azure_vm"
  instance_count = var.azure_instance_count
  location    = var.azure_location
}
