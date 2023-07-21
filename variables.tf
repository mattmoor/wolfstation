/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

variable "project" {
  description = "The project in which to create the cluster."
}

variable "region" {
  description = "The region in which to create the cluster."
  default     = "us-east4"
}

variable "name" {
  description = "The name of resources created in the project."
  default     = "work"
}

variable "machine_type" {
  description = "The machine type to use for the cluster."
  default     = "e2-standard-4"
}

variable "disk_gb" {
  description = "The size of the disk to use for the cluster."
  default     = 35
}

variable "idle_timeout" {
  description = "The idle timeout for the cluster."
  default     = "600s"
}

variable "running_timeout" {
  description = "The running timeout for the cluster."
  default     = "21600s"
}

variable "extra_packages" {
  description = "Additional packages to install."
  type        = list(string)
  default     = []
}
