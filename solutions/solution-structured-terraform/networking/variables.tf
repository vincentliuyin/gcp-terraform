variable "vpc_name" {
  description = "The name of the existing VPC."
  type        = string
  default     = "vpc-vincent-demo"
}



variable "subnet_ip_cidr" {
  description = "The IP CIDR range for the subnet."
  type        = string
  default     = "10.0.10.0/24"
}


