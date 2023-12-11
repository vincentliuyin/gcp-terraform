terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.8.0"
    }
  }

  backend "gcs" {
    bucket  = "terraform-state-vincent-demo"
    prefix  = "storage/state/${terraform.workspace}"
  }
}

provider "google" {
  credentials = file("/home/vliu/gcp-key/gcp-learning-401106-860e4685de9d.json")
  project     = "gcp-learning-401106"
  region      = local.region_mapping[terraform.workspace]
  # zone        = "us-central1-c"
}

locals {
  region_mapping = {
    "us-east1-test"      = "us-east1"
    "us-east1-dev"      = "us-east1"
    "us-east1-prod"      = "us-east1"
    "europe-west1"  = "europe-west1"

  }
}