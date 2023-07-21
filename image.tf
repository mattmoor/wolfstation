/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

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
  source = "chainguard-dev/apko/publisher"

  // TODO: use Artifact Registry, pre-create this repo.
  target_repository = "gcr.io/${var.project}/${var.name}"
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
    cmd        = "-c \"${join(" && ", local.startup_commands)}\""
  })
}
