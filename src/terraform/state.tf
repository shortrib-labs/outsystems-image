terraform {
  backend "gcs" {
    bucket = "terraform-state-outsystems-image"
    prefix = "terraform/state"
  }
}
