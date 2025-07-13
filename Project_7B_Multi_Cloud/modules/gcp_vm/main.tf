resource "google_compute_network" "main" {
  name                    = "${var.instance_name}-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "public" {
  name          = "${var.instance_name}-public-subnet"
  ip_cidr_range = var.subnet_cidr_block
  region        = var.region
  network       = google_compute_network.main.id
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.instance_name}-allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.allowed_cidr_blocks
  target_tags   = ["${var.instance_name}-vm"]
}

resource "google_compute_firewall" "http" {
  name    = "${var.instance_name}-allow-http"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = var.allowed_cidr_blocks
  target_tags   = ["${var.instance_name}-vm"]
}

resource "google_compute_firewall" "https" {
  name    = "${var.instance_name}-allow-https"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = var.allowed_cidr_blocks
  target_tags   = ["${var.instance_name}-vm"]
}

resource "google_compute_instance" "main" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = data.google_compute_image.ubuntu.self_link
      size  = var.root_volume_size
      type  = var.root_volume_type
    }
  }

  network_interface {
    network    = google_compute_network.main.name
    subnetwork = google_compute_subnetwork.public.name
    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    ssh-keys  = "${var.ssh_username}:${var.ssh_public_key}"
    user-data = templatefile("${path.module}/user-data.yml", {
      ssh_username = var.ssh_username
      gcp_region   = var.region
      zone         = data.google_compute_zones.available.names[0]
      instance_type = var.instance_type
      image        = data.google_compute_image.ubuntu.self_link
    })
  }

  tags = ["${var.instance_name}-vm"]

  labels = var.tags

  lifecycle {
    create_before_destroy = true
  }
}