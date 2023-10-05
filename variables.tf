variable "bucket_name" {
  description = "Name of the GCP storage bucket"
  type        = string
}

variable "bucket_location" {
  description = "Location of the GCP storage bucket"
  type        = string
  default     = "US"
}
