output "uploaded_file_url" {
  value       = "https://storage.googleapis.com/${google_storage_bucket.bucket.name}/example.txt"
  description = "The URL of the uploaded file."
}
