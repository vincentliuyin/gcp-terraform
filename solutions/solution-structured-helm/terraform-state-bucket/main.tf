resource "google_storage_bucket" "terraform_state" {
  name          = "terraform-state-vincent-demo"
  location      = "US"
  force_destroy = true

  versioning {
    enabled = true
  }


  labels = {
    devoteam = "true"
  }
}
