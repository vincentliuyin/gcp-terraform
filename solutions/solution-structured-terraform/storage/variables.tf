# variable "bucket_name" {
#   description = "The name of the Google Cloud Storage bucket."
#   type        = string
#   default     = "vincent-demo-bucket"
# }

variable "cloud_storage_content" {
  description = "The content to be written to the cloud storage file"
  type        = string
  default     = "Hello from GCP cloud storage"
}