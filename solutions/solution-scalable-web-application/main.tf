// Use existing VPC and Subnet
data "google_compute_network" "existing_vpc" {
  name = "default"
}

data "google_compute_subnetwork" "existing_subnet" {
  name = "default"
}

resource "google_compute_firewall" "allow_web_ssh" {
  name    = "allow-web-ssh"
  network = data.google_compute_network.existing_vpc.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  target_tags   = ["webserver"]
  source_ranges = ["0.0.0.0/0"]
}

// Instance Template
resource "google_compute_instance_template" "instance_template" {
  name_prefix = "${var.name_prefix}-template"
  machine_type = "f1-micro"
  tags = ["webserver"]
  disk {
    source_image = "projects/ubuntu-os-cloud/global/images/family/ubuntu-2004-lts"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = data.google_compute_network.existing_vpc.self_link
    subnetwork = data.google_compute_subnetwork.existing_subnet.self_link

    // Assign a public IP
    access_config {
      // You can specify a static external IP here if needed
      // nat_ip = google_compute_address.static_ip.address
    }
  }

  metadata_startup_script = <<-SCRIPT
    #!/bin/bash
    apt update
    apt install -y python3
    echo '<!DOCTYPE html><html><body><h1>Hello from ${var.ssh_username} VM!</h1></body></html>' > index.html
    python3 -m http.server 80 &
  SCRIPT

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.public_ssh_key_path)}"
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}



// Managed Instance Group
resource "google_compute_instance_group_manager" "instance_group" {
  name               = "${var.name_prefix}-instance-group"
  base_instance_name = "${var.name_prefix}-instance"
  zone               = "us-central1-a"
  target_size        = 3

  version {
    name              = "primary"
    instance_template = google_compute_instance_template.instance_template.self_link
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.auto_healing_check.self_link
    initial_delay_sec = 300
  }

  update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "REPLACE"
    max_surge_fixed       = 2
    max_unavailable_fixed = 1
    # min_ready_sec         = 20
  }


  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "auto_healing_check" {
  name               = "${var.name_prefix}-ah-check"
  check_interval_sec = 5
  timeout_sec        = 5
  http_health_check {
    port = 80
  }
}




