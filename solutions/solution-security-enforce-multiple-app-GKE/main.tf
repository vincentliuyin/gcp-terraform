resource "google_container_cluster" "primary" {
  name             = "vincent-gke-cluster2"
  location         = "us-central1-a"
  deletion_protection = false

  node_pool {
    name       = "pool1"
    node_count = 1

    node_config {
      machine_type = "e2-medium"
      labels = {
        type = "special"
      }

      taint {
        key    = "special"
        value  = "yes"
        effect = "NO_SCHEDULE"
      }
    }
  }
}

data "google_container_cluster" "primary" {
  name     = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
}

resource "local_file" "kube_config" {
  depends_on = [google_container_cluster.primary]

  content = <<EOT
apiVersion: v1
kind: Config
clusters:
- name: ${google_container_cluster.primary.name}
  cluster:
    certificate-authority-data: ${data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate}
    server: https://${data.google_container_cluster.primary.endpoint}
contexts:
- name: ${google_container_cluster.primary.name}
  context:
    cluster: ${google_container_cluster.primary.name}
    user: ${google_container_cluster.primary.name}
users:
- name: ${google_container_cluster.primary.name}
  user:
    auth-provider:
      name: gcp
current-context: ${google_container_cluster.primary.name}
EOT

  filename = "${path.module}/kubeconfig"
}

resource "null_resource" "set_kubeconfig" {
  depends_on = [local_file.kube_config]

  provisioner "local-exec" {
    command = <<EOT
      KUBECONFIG_PATH="${path.module}/kubeconfig"
      echo "export KUBECONFIG=$KUBECONFIG_PATH" >> ~/.bashrc
      export KUBECONFIG=$KUBECONFIG_PATH
    EOT
  }
}