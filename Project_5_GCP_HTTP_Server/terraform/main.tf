# Configure the Google Cloud provider using variables
provider "google" {
  credentials = file("~/.config/gcloud/application_default_credentials.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

# Create the compute instance (Ubuntu VM)
resource "google_compute_instance" "web" {
  name         = "webserver-instance"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["http-server", "ssh"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network       = "default"
    access_config {} # Ephemeral public IP
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_pub_key_path)}"
  }
}

# Open firewall access for HTTP (port 80)
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

# Output the VM's external IP
output "external_ip" {
  value = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}
