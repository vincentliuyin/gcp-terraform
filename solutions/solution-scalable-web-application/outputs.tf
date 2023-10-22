# data "google_compute_instance_group" "group" {
#   name = google_compute_instance_group_manager.instance_group.name
#   zone = "us-central1-a"
# }

# output "instance_public_ips" {
#   value = [
#     for instance in data.google_compute_instance_group.group.instances : 
#     lookup(instance, "named_ports", [])
#   ]
#   description = "The public IPs of the instances in the instance group."
# }

output "load_balancer_ip" {
  value       = google_compute_global_address.static_ip.address
  description = "The public IP address of the HTTP(S) Load Balancer."
}

// Output for the URL to access the VMs
output "vm_url" {
  value       = "http://${google_compute_global_address.static_ip.address}/test"
  description = "The URL for accessing the VMs via the HTTP(S) Load Balancer."
}