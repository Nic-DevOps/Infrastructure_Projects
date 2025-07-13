data "google_compute_image" "ubuntu" {
  family  = "ubuntu-2204-lts"
  project = "ubuntu-os-cloud"
}

data "google_compute_zones" "available" {
  region = var.region
}

data "google_client_config" "current" {}