# variable "location" {
#   description = "The location (region or zone) of the cluster"
#   type        = string
# }

# variable "dedicated_node_count" {
#   description = "Number of nodes in the dedicated node pool"
#   type        = number
# }

# variable "dedicated_machine_type" {
#   description = "Machine type of the dedicated node pool"
#   type        = string
# }

variable "deletion_protection" {
  description = "Enable or disable deletion protection for the cluster"
  type        = bool
  default     = false
}
