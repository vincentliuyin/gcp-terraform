#!/bin/bash

# Define the project directory
project_dir="terraform-state-bucket"

# Create the project directory
mkdir -p "$project_dir"
cd "$project_dir"

# Create the Terraform configuration files

# provider.tf
cat <<EOF >provider.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.0.0"
    }
  }
}

provider "google" {
  credentials = file("/home/vliu/gcp-key/gcp-learning-401106-860e4685de9d.json")
  project     = "gcp-learning-401106"
  region      = "us-central1"
  zone        = "us-central1-c"
}
EOF

# main.tf
cat <<EOF >main.tf
resource "google_storage_bucket" "terraform_state" {
  name          = "terraform-state-\${random_id.bucket_id.hex}"
  location      = "US"
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365
    }
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
EOF

# outputs.tf
cat <<EOF >outputs.tf
output "bucket_name" {
  value = google_storage_bucket.terraform_state.name
}
EOF

echo "Terraform project for state bucket creation has been set up in $project_dir."
