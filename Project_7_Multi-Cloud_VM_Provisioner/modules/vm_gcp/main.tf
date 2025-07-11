resource "google_compute_instance" "vm" {
  count        = var.instance_count
  name         = "gcp-vm-${count.index}"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"

    access_config {}
  }
}
