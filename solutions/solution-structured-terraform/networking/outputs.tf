output "vpc_id" {
  value       = data.google_compute_network.existing_vpc.id
  description = "The ID of the existing VPC."
}

output "subnet_ids" {
  value       = [google_compute_subnetwork.subnet.id]
  description = "A list of IDs of the created subnets."
}
