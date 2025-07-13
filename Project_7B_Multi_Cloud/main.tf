resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "aws_vm" {
  count = var.deploy_aws ? 1 : 0
  source = "./modules/aws_vm"

  instance_name = local.instance_names.aws
  instance_type = var.aws_instance_type

  vpc_cidr_block    = local.network_config.aws.cidr_block
  subnet_cidr_block = local.network_config.aws.subnet_cidr

  ssh_public_key    = local.ssh_public_key
  ssh_username      = var.ssh_username

  allowed_cidr_blocks = var.allowed_cidr_blocks
  tags                = local.common_tags
}

module "azure_vm" {
  count = var.deploy_azure ? 1 : 0
  source = "./modules/azure_vm"

  instance_name = local.instance_names.azure
  vm_size       = var.azure_vm_size
  location      = var.azure_region

  vnet_cidr_block   = local.network_config.azure.cidr_block
  subnet_cidr_block = local.network_config.azure.subnet_cidr

  ssh_public_key = local.ssh_public_key
  ssh_username   = var.ssh_username

  allowed_cidr_blocks = var.allowed_cidr_blocks
  tags                = local.common_tags
}

module "gcp_vm" {
  count = var.deploy_gcp ? 1 : 0
  source = "./modules/gcp_vm"

  instance_name = local.instance_names.gcp
  machine_type  = var.gcp_machine_type
  zone          = var.gcp_zone

  network_cidr_block = local.network_config.gcp.cidr_block
  subnet_cidr_block  = local.network_config.gcp.subnet_cidr

  ssh_public_key = local.ssh_public_key
  ssh_username   = var.ssh_username

  allowed_cidr_blocks = var.allowed_cidr_blocks
  tags                = local.common_tags
}
