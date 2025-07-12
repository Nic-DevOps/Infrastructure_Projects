locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }

  instance_names = {
    aws   = "${var.project_name}-${var.environment}-aws-vm"
    azure = "${var.project_name}-${var.environment}-azure-vm"
    gcp   = "${var.project_name}-${var.environment}-gcp-vm"
  }

  ssh_public_key = file(var.ssh_public_key_path)

  network_config = {
    aws = {
      cidr_block = "10.0.0.0/16"
      subnet_cidr = "10.0.1.0/24"
    }
    azure = {
      cidr_block = "10.1.0.0/16"
      subnet_cidr = "10.1.1.0/24"
    }
    gcp = {
      cidr_block = "10.2.0.0/16"
      subnet_cidr = "10.2.1.0/24"
    }
  }
}
