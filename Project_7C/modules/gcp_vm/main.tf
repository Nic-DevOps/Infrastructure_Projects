###############################################################################
# GCP VM Module – minimal e2‑micro instance.                                   #
###############################################################################

variable "gcp_region" {}
variable "ssh_pub_key" {}
variable "labels" {
  type = map(string)
}


###############################################################################
# Networking – VPC + Subnet                                                   #
###############################################################################

# Reserve a small VPC network.
resource "google_compute_network" "vm_net" {
  name                    = "${var.labels.project}-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vm_subnet" {
  name          = "${var.labels.project}-subnet"
  ip_cidr_range = "10.20.1.0/24"
  network       = google_compute_network.vm_net.id
  region        = var.gcp_region
}

# Allow SSH ingress via firewall rule.
resource "google_compute_firewall" "vm_fw" {
  name    = "${var.labels.project}-allow-ssh"
  network = google_compute_network.vm_net.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.labels.project}-vm"]
}

###############################################################################
# Instance                                                                 #
###############################################################################

resource "google_compute_instance" "vm" {
  name         = "${var.labels.project}-gcp-vm"
  machine_type = "e2-micro" # Free‑tier
  zone         = "${var.gcp_region}-a"

  tags = ["${var.labels.project}-vm"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20250712"
      size  = 10
    }
  }

  network_interface {
    network    = google_compute_network.vm_net.id
    subnetwork = google_compute_subnetwork.vm_subnet.id

    access_config {
      # Ephemeral public IP
    }
  }

  metadata = {
    # Inject SSH key.
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