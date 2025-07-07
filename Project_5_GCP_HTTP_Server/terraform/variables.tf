# Define the GCP project ID
variable "project_id" {
  description = "The ID of your Google Cloud project"
  type        = string
}

# Set the region where resources will be deployed
variable "region" {
  description = "The GCP region to deploy the resources"
  type        = string
  default     = "us-west1"
}

# Set the zone (availability zone within the region)
variable "zone" {
  description = "The GCP zone to deploy the resources"
  type        = string
  default     = "us-west1-b"
}

# Path to the public SSH key to allow login to the VM
variable "ssh_pub_key_path" {
  description = "The path to your SSH public key file"
  type        = string
  default     = "~/.ssh/project5_key.pub"
}
