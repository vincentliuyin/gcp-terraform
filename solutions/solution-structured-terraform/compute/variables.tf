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
