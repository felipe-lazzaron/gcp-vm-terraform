provider "google" {
  credentials = file(var.google_credentials)
  project     = var.google_project
  region      = var.google_region
}
