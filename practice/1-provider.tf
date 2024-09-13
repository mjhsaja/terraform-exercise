# Init command
# gcloud auth login
# gcloud config set project mashanz-software-engineering
# terraform init

# For linting and formatting, check: https://developer.hashicorp.com/terraform/language/style

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = var.project_id
  region = var.region
}

# https://terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "onxp-terraform"
    prefix = "terraform-state/bootcamp"
  }

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.14.0"
    }
  }
}
