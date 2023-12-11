# Access the remote state
data "terraform_remote_state" "network" {
  backend = "gcs"
  config = {
    bucket = "terraform-state-vincent-demo"
    prefix = "network/state/${terraform.workspace}"
  }
}

# Firewall resource
resource "google_compute_firewall" "firewall" {
  name    = "vincent-demo-firewall-${terraform.workspace}"
  network = data.terraform_remote_state.network.outputs.vpc_id

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080"]
  }

  target_tags   = ["${var.firewall_target_tag}"]
  source_ranges = ["0.0.0.0/0"]
}
