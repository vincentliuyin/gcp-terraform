variable "name_prefix" {
  type        = string
  description = "The prefix for the names of created resources"
}

variable "subnet_cidr" {
  type        = string
  description = "The IP CIDR range of the subnet"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the DNS zone and record"
}

variable "managed_zone" {
  type        = string
  description = "The name for an existing managed zone"
}

variable "public_ssh_key_path" {
  type        = string
  description = "The path to the public SSH key to be added to the VM"
}

variable "ssh_username" {
  type        = string
  description = "The SSH username to be used for the VM"
}
