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
    apt install -y python3 python3-pip
    pip3 install Flask
    cat <<EOF > app.py
    from flask import Flask
    import socket

    app = Flask(__name__)

    @app.route('/')
    def hello():
        return '<!DOCTYPE html><html><body><h1>Hello from VM: {}</h1></body></html>'.format(socket.gethostname())

    @app.route('/test')
    def test():
        return '<!DOCTYPE html><html><body><h1>Hello from VM: {} at /test</h1></body></html>'.format(socket.gethostname())

    if __name__ == '__main__':
        app.run(host='0.0.0.0', port=80)
    EOF
    python3 app.py &
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
  target_size        = var.target_size

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

// Backend Service
resource "google_compute_backend_service" "backend_service" {
  name        = "${var.name_prefix}-backend-service"
  protocol    = "HTTP"
  timeout_sec = 10

  backend {
    group = google_compute_instance_group_manager.instance_group.instance_group
  }

  health_checks = [google_compute_health_check.auto_healing_check.self_link]
  session_affinity = "CLIENT_IP"
}

// URL Map
// URL Map with Path Matcher
// URL Map with Path Matcher
resource "google_compute_url_map" "url_map" {
  name = "${var.name_prefix}-url-map"

  default_service = google_compute_backend_service.backend_service.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "pathmatcher"
  }

  path_matcher {
    name            = "pathmatcher"
    default_service = google_compute_backend_service.backend_service.self_link

    path_rule {
      paths        = ["/test/*"]
      service      = google_compute_backend_service.backend_service.self_link
    }
  }
}



// Target HTTP Proxy
resource "google_compute_target_http_proxy" "http_proxy" {
  name   = "${var.name_prefix}-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

// Forwarding Rule
# resource "google_compute_global_forwarding_rule" "forwarding_rule" {
#   name       = "${var.name_prefix}-forwarding-rule"
#   target     = google_compute_target_http_proxy.http_proxy.self_link
#   port_range = "80"

# }

// Reserve a Static IP Address
resource "google_compute_global_address" "static_ip" {
  name = "${var.name_prefix}-static-ip"
}


resource "google_compute_global_forwarding_rule" "forwarding_rule_static_ip" {
  name       = "${var.name_prefix}-forwarding-rule-static-ip"
  target     = google_compute_target_http_proxy.http_proxy.self_link
  port_range = "80"

  ip_address = google_compute_global_address.static_ip.address
}

resource "google_dns_record_set" "lb_dns_record" {
  name         = "www.${var.domain_name}"
  type         = "A"
  ttl          = 300
  managed_zone = "${var.managed_zone}"
  rrdatas      = [google_compute_global_address.static_ip.address]
}



