output "vm_external_ip" {
  description = "The external IP of the VM instance"
  value       = google_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}

output "website_domain_name" {
  description = "The DNS zone name"
  value       = trimsuffix(google_dns_record_set.dns_record.name,".")
}
