terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.8.0"
    }
  }
}

provider "google" {
  credentials = file("/home/vliu/gcp-key/gcp-learning-401106-860e4685de9d.json")
  project     = "gcp-learning-401106"
  region      = "us-central1"
  zone        = "us-central1-c"
}
