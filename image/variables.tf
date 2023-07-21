/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

variable "target_repository" {
  description = "The repository to push the image to."
}

variable "extra_packages" {
  description = "Additional packages to install."
  type        = list(string)
  default     = []
}
