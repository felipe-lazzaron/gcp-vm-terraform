resource "google_compute_instance" "default" {
  name         = "nome-da-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // IP externo
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${path.module}/id_ed25519.pub")}"
  }
}
