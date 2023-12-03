resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"

  node_pool {
    name       = "pool1"
    node_count = 1

    node_config {
      machine_type = "e2-medium"
    }
  }
}