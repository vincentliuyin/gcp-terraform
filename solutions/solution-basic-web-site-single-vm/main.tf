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
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "username:${file(var.public_ssh_key_path)}"
  }

  metadata_startup_script = <<SCRIPT
    #!/bin/bash
    apt update
    apt install -y python3 python3-pip
    pip3 install Flask
    echo 'from Flask import Flask
app = Flask(__name__)

@app.route("/vm")
def hello():
    return "Hello from VM!"' > app.py
    nohup python3 app.py &
SCRIPT
}

resource "google_dns_managed_zone" "dns_zone" {
  name        = "${var.name_prefix}-zone"
  dns_name    = var.domain_name
  description = "DNS Zone for ${var.domain_name}"
}

resource "google_dns_record_set" "dns_record" {
  name         = "www.${var.domain_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.dns_zone.name
  rrdatas      = [google_compute_instance.vm.network_interface[0].access_config[0].nat_ip]
}
