resource "google_compute_firewall" "allow_squid" {
  name    = "allow-squid"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8088"]
  }

  source_ranges = ["0.0.0.0/0"]  // Considerar restringir isso para aumentar a segurança
  target_tags   = ["squid-vm"]
}
