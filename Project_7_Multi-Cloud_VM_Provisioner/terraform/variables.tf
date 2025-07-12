# AWS Variables
variable "aws_region" {
  description = "The AWS region to deploy into"
  default     = "us-west-2"
}

variable "aws_instance_count" {
  description = "Number of AWS instances to create"
  default     = 1
}

# GCP Variables
variable "gcp_project" {
  description = "GCP project ID to use"
  type        = string
  default     = "infrastructure-projects-465608"
}

variable "gcp_region" {
  description = "The GCP region to deploy into"
  default     = "us-central1"
}

variable "gcp_instance_count" {
  description = "Number of GCP instances to create"
  default     = 1
}

variable "gcp_subnet_self_link" {
  type = string
}
variable "gcp_zone" {
  description = "GCP zone to deploy the instance into"
  type        = string
}


# Azure Variables
variable "azure_location" {
  description = "Azure region to deploy into"
  default     = "East US"
}

variable "azure_instance_count" {
  description = "Number of Azure instances to create"
  default     = 1
}

variable "azure_resource_group" {
  type = string
}

variable "azure_subnet_id" {
  type = string
}

