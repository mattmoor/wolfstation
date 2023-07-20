/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

terraform {
  required_providers {
    apko   = { source = "chainguard-dev/apko" }
    cosign = { source = "chainguard-dev/cosign" }
    oci    = { source = "chainguard-dev/oci" }
  }
}

variable "target_repository" {
  description = "The docker repo into which the image and attestations should be published."
}

variable "extra_packages" {
  description = "Additional packages to install."
  type        = list(string)
  default     = []
}

provider "apko" {
  extra_repositories = ["https://packages.wolfi.dev/os"]
  extra_keyring      = ["https://packages.wolfi.dev/os/wolfi-signing.rsa.pub"]
  default_archs      = ["x86_64", "aarch64"]
  extra_packages     = ["wolfi-baselayout"]
}

locals {
  startup_commands = [
    # Create a user named "user" with no password and passwordless sudo access.
    "(adduser -D user -s /bin/sh)",
    "passwd -d user",

    # Set up and launch sshd, by setting up the host keys and config that allow for empty passwords.
    "(yes | ssh-keygen -q -f /etc/ssh/ssh_host_rsa_key -t rsa -C 'host' -N '')",
    "mkdir /var/empty",
    "(echo 'PermitEmptyPasswords yes' > /etc/ssh/sshd_config)",
    "/usr/sbin/sshd",

    # Cloud workstations require the container entrypoint to block forever.
    "sleep infinity",
  ]
}

module "image" {
  source  = "chainguard-dev/apko/publisher"

  target_repository = var.target_repository
  config = jsonencode({
    contents = {
      packages = concat([
        # This is so we have a shell and posix tools (e.g. we need this for sh, sleep, adduser)
        "busybox",

        # This is how Cloud Workstations connects to the container.
        "openssh-server",
      ], var.extra_packages)
    }
    entrypoint = { command = "/bin/sh" }
    cmd = "-c \"${join(" && ", local.startup_commands)}\""
  })
}

resource "oci_tag" "latest" {
  digest_ref = module.image.image_ref
  tag        = "latest"
}

output "image_ref" {
  value = oci_tag.latest.tagged_ref
}
