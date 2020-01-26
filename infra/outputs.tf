output "site_instance_ip" {
  value = google_compute_address.site_static_ip.address
}
