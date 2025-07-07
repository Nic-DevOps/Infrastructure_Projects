# Configure the Google Cloud provider
provider "google" {
  # Use your local gcloud credentials for authentication
  credentials = file("~/.config/gcloud/application_default_credentials.json")

  # Specify your GCP project ID
  project = "project-5-terraform-ansible"

  # Region to deploy resources in
  region  = "us-central1"

  # Specific zone within the region
  zone    = "us-central1-a"
}

# Create a Compute Engine VM instance
resource "google_compute_instance" "web" {
  # Name of the VM
  name         = "webserver-instance"

  # Machine type (e2-micro is free-tier eligible)
  machine_type = "e2-micro"

  # Zone to deploy this VM
  zone         = "us-central1-a"

  # Add network tags (used by firewall rules)
  tags = ["http-server", "ssh"]

  # Configure the boot disk
  boot_disk {
    initialize_params {
      # Use Ubuntu 22.04 LTS image
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  # Configure the network interface
  network_interface {
    # Use the default VPC network
    network = "default"

    # Create an ephemeral public IP for external access
    access_config {}
  }

  # Inject your public SSH key for the 'ubuntu' user
  metadata = {
    # Format: USERNAME:PUBLIC_KEY
    ssh-keys = "ubuntu:${file("~/.ssh/project5_key.pub")}"
  }
}

# Create a firewall rule to allow HTTP traffic on port 80
resource "google_compute_firewall" "allow_http" {
  # Unique name for the firewall rule
  name    = "allow-http"

  # Apply rule to the default VPC network
  network = "default"

  # Allow TCP traffic on port 80
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Target instances with this network tag
  target_tags = ["http-server"]

  # Inbound traffic only
  direction = "INGRESS"

  # Allow from any IP (worldwide access)
  source_ranges = ["0.0.0.0/0"]
}

# Output the external IP of the instance after creation
output "external_ip" {
  # Gets the first external IP address of the instance
  value = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}
