
resource "google_service_account" "onxp-bootcamp-k8s-sa" {
  account_id   = "onxp-bootcamp-k8s-sa"
  display_name = "OnXP K8s Service Account"
}

# create kubernetes master -> VPC Google
resource "google_container_cluster" "onxp-bootcamp-cluster" {
  name     = "onxp-bootcamp-cluster"
  location = "${var.region}-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  network = google_compute_network.onxp-bootcamp-vpc.self_link
  subnetwork = google_compute_subnetwork.onxp-bootcamp-subnet.self_link
  logging_service = "none"
  monitoring_service = "none"
  networking_mode = "VPC_NATIVE"

  addons_config {
    horizontal_pod_autoscaling {
      disabled = true
    }

    http_load_balancing {
      disabled = true
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  ip_allocation_policy {
    cluster_secondary_range_name = google_compute_subnetwork.onxp-bootcamp-subnet.secondary_ip_range[0].range_name # pods/container di dalam VM instance (cluster)
    services_secondary_range_name = google_compute_subnetwork.onxp-bootcamp-subnet.secondary_ip_range[1].range_name # services
  }

  private_cluster_config {
    enable_private_nodes = true
    # kita pengen control k8s dari local
    enable_private_endpoint = false
    master_ipv4_cidr_block = "172.24.0.0/28"
  }
}


resource "google_container_node_pool" "onxp-bootcamp-node-pool" {
  name       = "onxp-bootcamp-node-pool"
  location   = "${var.region}-a"
  cluster    = google_container_cluster.onxp-bootcamp-cluster.name
  node_count = 1

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
    "${var.region}-a"
  ]

  node_config {
    preemptible  = true
    machine_type = "e2-micro"
    disk_size_gb = 30
    disk_type    = "pd-standard"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.onxp-bootcamp-k8s-sa.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}