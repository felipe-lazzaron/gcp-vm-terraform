output "vm_external_ip" {
  value = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
  description = "The external IP address of the VM"
}
