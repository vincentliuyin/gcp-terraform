output "bucket_url" {
  value       = google_storage_bucket.bucket.url
  description = "The URL of the created bucket"
}
