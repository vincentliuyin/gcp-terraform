resource "google_compute_network" "vpc" {
  name = "${var.name_prefix}-vpc"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.name_prefix}-subnet"
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc.name
}

resource "google_compute_firewall" "firewall" {
  name    = "${var.name_prefix}-firewall"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  target_tags   = ["web"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm" {
  name         = "${var.name_prefix}-vm"
  machine_type = "f1-micro"

  tags = ["web"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
 
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.public_ssh_key_path)}"
  }

  metadata_startup_script = <<SCRIPT
    #!/bin/bash
    apt update
    apt install -y python3
    echo '<!DOCTYPE html><html><body><h1>Hello from ${var.ssh_username} VM!</h1></body></html>' > index.html
    python3 -m http.server 80 &
SCRIPT
}


resource "google_dns_record_set" "dns_record" {
  name         = "www.${var.domain_name}"
  type         = "A"
  ttl          = 300
  managed_zone = "${var.managed_zone}"
  rrdatas      = [google_compute_instance.vm.network_interface[0].access_config[0].nat_ip]
}
