#!/bin/bash

# Define categories for Terraform projects
categories=("networking" "compute" "storage" "functions" "database")

# Base Terraform provider configuration
provider_config='terraform {
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
}'

# Create directories and files
for category in "${categories[@]}"; do
  # Create a directory for the category
  mkdir -p "$category"

  # Navigate into the category directory
  cd "$category"

  # Create a standard Terraform project structure
  mkdir -p "modules"
  touch main.tf outputs.tf variables.tf

  # Inject the provider configuration
  echo "$provider_config" > provider.tf

  # Navigate back to the base directory
  cd ..

  echo "Created Terraform project for $category"
done

echo "All Terraform projects are set up."
