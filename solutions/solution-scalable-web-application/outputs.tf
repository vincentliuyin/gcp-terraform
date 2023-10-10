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
