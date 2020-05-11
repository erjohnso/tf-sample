provider "google" {
  credentials = file("/home/erjohnso/.tf-sample.json")
  project = "external-graphite-demos"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_instance" "demo_vm" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network       = google_compute_network.vpc_network.self_link
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = "demo-network"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "web_firewall" {
  name    = "web-firewall"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_tags = ["web"]
}
