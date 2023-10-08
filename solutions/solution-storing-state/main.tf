terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      # version = "5.0.0"
    }
  }
}

provider "google" {
  credentials = file("/home/vliu/gcp-key/gcp-learning-401106-860e4685de9d.json")
  project     = "gcp-learning-401106"
  region      = "us-central1"
  zone        = "us-central1-c"
}



resource "google_storage_bucket" "terraform-bucket-for-state" {
  name                        = "bucket-dev-eu"
  location                    = "us-central1"
  
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }
  labels = {
    "environment" = "jorgebernhnardt"
  }
}

