# GCP Infrastructure Setup with Terraform

This repository contains various solutions for setting up infrastructure on Google Cloud Platform (GCP) using Terraform. Each solution is encapsulated in its own directory under the `solutions` folder, providing a modular and organized structure.

## Solutions

| Solution Name | Description | Link |
|---------------|-------------|------|
| Basic Web Site (Single VM) | A basic setup for a web site hosted on a single VM instance in GCP. | [Go to Solution](./solutions/solution-basic-web-site-single-vm/readme.md) |


## Basic Flow of Terraform

1. **Initialize**: Initialize your Terraform working directory.
   ```sh
   terraform init
1. **plan**: Preview the changes to be made.
   ```sh
   terraform plan
1. **apply**: Apply the desired changes.
   ```sh
   terraform apply
1. **destroy**: (Optional) Destroy the resources.
   ```sh
   terraform destroy

For detailed documentation and advanced use-cases, please refer to the official Terraform documentation.

