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

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest
provider "cloudflare" {
  # or configure via env CLOUDFLARE_API_TOKEN
  # api_token = xyz"
}


# https://terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "onxp-terraform"
    prefix = "terraform/bootcamp"
  }

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.14.0"
    }

    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "4.34.0"
    }
  }
}

# get creds
# gcloud config set project mashanz-software-engineering
# gcloud container clusters get-credentials onxp-bootcamp-cluster  --region=us-central1-a