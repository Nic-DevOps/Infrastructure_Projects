variable "aws_region" {
  default = "us-west-2"
}

variable "aws_instance_count" {
  default = 1
}

variable "gcp_region" {
  default = "us-central1"
}

variable "gcp_project" {
  type = string
}

variable "gcp_instance_count" {
  default = 1
}

variable "azure_location" {
  default = "East US"
}

variable "azure_instance_count" {
  default = 1
}
