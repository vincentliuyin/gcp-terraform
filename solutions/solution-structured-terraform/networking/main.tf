data "google_compute_network" "existing_vpc" {
  name = var.vpc_name
}

resource "google_compute_subnetwork" "subnet" {
  name          = "vincent-demo-subnet-${terraform.workspace}"
  network       = data.google_compute_network.existing_vpc.id
  ip_cidr_range = var.subnet_ip_cidr
}

# Add more subnetwork resources as needed
