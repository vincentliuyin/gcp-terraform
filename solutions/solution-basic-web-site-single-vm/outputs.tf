output "vm_external_ip" {
  description = "The external IP of the VM instance"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "dns_zone_name" {
  description = "The DNS zone name"
  value       = google_dns_managed_zone.dns_zone.dns_name
}
