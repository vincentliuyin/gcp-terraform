resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  resource_labels = {
    deletion_protection = var.deletion_protection ? "true" : "false"
  }

  node_pool {
    name       = "pool1"
    node_count = 1

    node_config {
      machine_type = "e2-medium"
    }
  }
}