output "instance_id" {
  description = "ID of the Compute Engine instance"
  value       = google_compute_instance.main.id
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = google_compute_instance.main.network_interface[0].network_ip
}

output "public_dns" {
  description = "Public DNS name of the instance"
  value       = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = google_compute_network.main.id
}

output "subnet_id" {
  description = "ID of the subnet"
  value       = google_compute_subnetwork.public.id
}

output "firewall_rules" {
  description = "Names of the firewall rules"
  value = [
    google_compute_firewall.ssh.name,
    google_compute_firewall.http.name,
    google_compute_firewall.https.name
  ]
}

output "image_id" {
  description = "Image ID used for the instance"
  value       = data.google_compute_image.ubuntu.self_link
}

output "zone" {
  description = "Zone of the instance"
  value       = google_compute_instance.main.zone
}

output "machine_type" {
  description = "Machine type of the instance"
  value       = google_compute_instance.main.machine_type
}