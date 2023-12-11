data "google_compute_network" "existing_vpc" {
  name = var.vpc_name
}

resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-name"
  network       = data.google_compute_network.existing_vpc.id
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
}

# Add more subnetwork resources as needed
