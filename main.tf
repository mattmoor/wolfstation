/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

terraform {
  required_providers {
    apko = {
      source = "chainguard-dev/apko"
    }
    cosign = {
      source = "chainguard-dev/cosign"
    }
    oci = {
      source = "chainguard-dev/oci"
    }
  }
}

variable "target_repository" {
  description = "The docker repo into which the image and attestations should be published."
}

provider "apko" {
  extra_repositories = ["https://packages.wolfi.dev/os"]
  extra_keyring      = ["https://packages.wolfi.dev/os/wolfi-signing.rsa.pub"]
  default_archs      = ["x86_64", "aarch64"]
  extra_packages     = ["wolfi-baselayout"]
}

module "image" {
  source  = "chainguard-dev/apko/publisher"

  target_repository = var.target_repository
  config = file("${path.module}/apko.yaml")
}

resource "oci_tag" "latest" {
  digest_ref = module.image.image_ref
  tag        = "latest"
}

output "image_ref" {
  value = oci_tag.latest.tagged_ref
}
