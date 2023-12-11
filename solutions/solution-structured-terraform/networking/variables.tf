variable "vpc_name" {
  description = "The name of the existing VPC."
  type        = string
  default     = "vpc-vincent-demo"
}

variable "region" {
  description = "The region where to create the subnets."
  type        = string
  default     = "us-central1"
}

# Add more variables if needed
