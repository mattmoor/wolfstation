/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

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

resource "google_workstations_workstation_config" "default" {
  provider               = google-beta
  workstation_config_id  = var.name
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = var.region

  idle_timeout    = var.idle_timeout
  running_timeout = var.running_timeout

  host {
    gce_instance {
      machine_type                = var.machine_type
      boot_disk_size_gb           = var.disk_gb
      disable_public_ip_addresses = true
    }
  }

  container {
    image = module.image.image_ref
  }
}

resource "google_workstations_workstation" "default" {
  provider               = google-beta
  workstation_id         = var.name
  workstation_config_id  = google_workstations_workstation_config.default.workstation_config_id
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = var.region
}
