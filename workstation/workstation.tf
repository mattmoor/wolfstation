/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_network" "default" {
  provider                = google-beta
  name                    = var.name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "default" {
  provider      = google-beta
  name          = var.name
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.default.name
}

resource "google_workstations_workstation_cluster" "default" {
  provider               = google-beta
  workstation_cluster_id = var.name
  network                = google_compute_network.default.id
  subnetwork             = google_compute_subnetwork.default.id
  location               = var.region
}

data "google_compute_default_service_account" "default" {}

resource "google_workstations_workstation_config" "default" {
  provider               = google-beta
  workstation_config_id  = var.name
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = var.region

  idle_timeout    = var.idle_timeout
  running_timeout = var.running_timeout

  host {
    gce_instance {
      machine_type      = var.machine_type
      boot_disk_size_gb = var.disk_gb
      // TODO: make this true and figure out how to give it access to the image.
      disable_public_ip_addresses = false
      // TODO: Use a less permissive service account.
      service_account = data.google_compute_default_service_account.default.email
    }
  }

  container {
    image = var.image
  }
}

resource "google_workstations_workstation" "default" {
  provider               = google-beta
  workstation_id         = var.name
  workstation_config_id  = google_workstations_workstation_config.default.workstation_config_id
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = var.region
}
