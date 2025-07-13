variable "instance_name" {
  description = "Name of the Compute Engine instance"
  type        = string
}

variable "instance_type" {
  description = "Compute Engine machine type"
  type        = string
  default     = "e2-micro"
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "subnet_cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ssh_public_key" {
  description = "SSH public key for instance access"
  type        = string
}

variable "ssh_username" {
  description = "SSH username"
  type        = string
  default     = "ubuntu"
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "tags" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "pd-standard"
}
variable "machine_type" {
  description = "The machine type for the GCP VM"
  type        = string
}

variable "zone" {
  description = "The GCP zone to deploy the VM into"
  type        = string
}

variable "network_cidr_block" {
  description = "CIDR block for the GCP VPC network"
  type        = string
}
