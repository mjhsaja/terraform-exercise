# [Recommendation] Service Account for Node Pool
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "kubernetes-onxp-sa" {
  account_id   = "kubernetes-onxp-sa"
}

# Default Node Pool
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool
resource "google_container_node_pool" "onxp-node-pool" {
  name       = "onxp-node-pool"
  cluster    = google_container_cluster.onxp-kubernetes.id
  node_count = 1

  autoscaling {
    min_node_count = 1
    max_node_count = 10
    location_policy = "BALANCED"
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }

  node_locations = [ "us-central1-a" ]

  node_config {
    preemptible  = true
    machine_type = "e2-micro"
    disk_size_gb = 30
    disk_type = "pd-balanced"

    service_account = google_service_account.kubernetes-onxp-sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

# alternative nodepool
resource "google_container_node_pool" "onxp-alt-pool" {
  name = "onxp-alt-pool"
  cluster = google_container_cluster.onxp-kubernetes.id

  management {
    auto_repair = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 2
    location_policy = "BALANCED"
  }

  node_locations = [
    "asia-southeast2-a"
  ]

  node_config {
    preemptible = false
    machine_type = "e2-small"
    disk_size_gb = 30
    disk_type = "pd-balanced"

    labels = {
      operation = "onxp-alt-pool"
    }

    service_account = google_service_account.kubernetes-onxp-sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}