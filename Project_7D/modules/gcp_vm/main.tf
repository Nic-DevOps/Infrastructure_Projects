###############################################################################
# GCP VM Module – minimal e2‑micro instance.                                   #
###############################################################################

variable "gcp_region" {}
variable "ssh_pub_key" {}
variable "labels" {
  type = map(string)
}
variable "network_id" {
  description = "ID of the shared VPC network"
  type        = string
}

variable "subnet_id" {
  description = "ID of the shared subnet"
  type        = string
}

variable "firewall_tag" {
  description = "Tag for assigning firewall rules"
  type        = string
}

variable "instance_index" {
  description = "Index of the instance when module is counted"
  type        = number
}


###############################################################################
# Instance                                                                 #
###############################################################################

resource "google_compute_instance" "vm" {
  name         = "${var.labels.project}-gcp-vm-${var.instance_index}"
  machine_type = "e2-micro"
  zone         = "${var.gcp_region}-a"

  tags = [var.firewall_tag]

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20250712"
      size  = 10
    }
  }

  network_interface {
    network    = var.network_id
    subnetwork = var.subnet_id

    access_config {}
  }

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_pub_key}"
  }

  labels = var.labels
}


###############################################################################
# Outputs                                                                     #
###############################################################################

output "public_ip" {
  value = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}