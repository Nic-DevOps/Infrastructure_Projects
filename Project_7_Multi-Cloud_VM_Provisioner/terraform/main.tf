module "vm_aws" {
  source      = "../modules/vm_aws"
  instance_count = var.aws_instance_count
  region      = var.aws_region
}

module "vm_gcp" {
  source           = "../modules/vm_gcp"
  instance_count   = var.gcp_instance_count
  region           = var.gcp_region
  subnet_self_link = var.gcp_subnet_self_link
}


module "vm_az" {
  source            = "../modules/vm_az"
  instance_count    = var.azure_instance_count
  location          = var.azure_location
  resource_group    = var.azure_resource_group
  subnet_id         = var.azure_subnet_id
  ssh_public_key    = file("~/.ssh/id_rsa.pub")  # Adjust path if needed
}
