variable "vm_name" {
  description = "Name of the VM instance"
  type        = string
  default     = "vincent-demo-vm"
}

variable "public_ssh_key_path" {
  description = "Path to the public SSH key"
  type        = string
  default     = "/home/vliu/.ssh/id_ed25519.pub"
}

variable "ssh_username" {
  description = "SSH username"
  type        = string
  default     = "vincent"
}
