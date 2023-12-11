resource "google_storage_bucket" "bucket" {
  name          = "vincent-demo-bucket-${terraform.workspace}"
  location      = "US"
  force_destroy = true

  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "public_access" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"

  members = [
    "allUsers",
  ]
}

resource "local_file" "example" {
  content  = var.cloud_storage_content
  filename = "${path.module}/example.txt"
}

resource "null_resource" "upload_file" {
  depends_on = [google_storage_bucket.bucket, local_file.example]

  provisioner "local-exec" {
    command = <<EOF
      gsutil cp ${local_file.example.filename} gs://${google_storage_bucket.bucket.name}/
      rm ${local_file.example.filename}
    EOF
  }
}
