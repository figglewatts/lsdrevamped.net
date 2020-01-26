# TODO: change to DigitalOcean when my GCP free tier runs out ;)

terraform {
  required_version = ">= 0.12"
  backend "s3" {
    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_get_ec2_platforms      = true
    skip_metadata_api_check     = true
    endpoint                    = "https://fra1.digitaloceanspaces.com"
    region                      = "eu-west-1" # this isn't used
    key                         = "lsdrevamped.net.tfstate"
  }
}

provider "google" {
  credentials = file(var.gcp_creds_file)
  project     = "lsdrevamped"
  region      = "us-east1"
  zone        = "us-east1-b"

  version = "~> 3.5"
}

resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "site_subnet" {
  name          = "site-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc_network.self_link
}

resource "google_compute_firewall" "vpc_firewall" {
  name    = "vpc-firewall"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = google_compute_instance.site_instance.tags
}

resource "google_compute_address" "site_static_ip" {
  name = "site-static-ip"
}

resource "google_compute_instance" "site_instance" {
  name         = "site-instance"
  machine_type = "f1-micro"
  tags         = ["site-instance"]

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.site_subnet.self_link

    access_config {
      nat_ip = google_compute_address.site_static_ip.address
    }
  }

  metadata = {
    enable-oslogin = "FALSE"
    ssh-keys       = "user:${var.ssh_public_key}"
    startup-script = file("scripts/docker-compose-alias.sh")
  }
}
