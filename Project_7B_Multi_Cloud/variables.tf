variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "multi-cloud-vm"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops-team"
}

variable "deploy_aws" {
  description = "Whether to deploy AWS resources"
  type        = bool
  default     = true
}

variable "deploy_azure" {
  description = "Whether to deploy Azure resources"
  type        = bool
  default     = true
}

variable "deploy_gcp" {
  description = "Whether to deploy GCP resources"
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "aws_instance_type" {
  description = "AWS instance type"
  type        = string
  default     = "t3.micro"
}

variable "azure_region" {
  description = "Azure region"
  type        = string
  default     = "West US 2"
}

variable "azure_vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B1s"
}

variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-west1"
}

variable "gcp_zone" {
  description = "GCP zone"
  type        = string
  default     = "us-west1-a"
}

variable "gcp_machine_type" {
  description = "GCP machine type"
  type        = string
  default     = "e2-micro"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_username" {
  description = "SSH username for instances"
  type        = string
  default     = "ubuntu"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the instances"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
