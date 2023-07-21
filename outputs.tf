/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

locals { local_port = 22 }

output "start_command" {
  value = <<EOF
gcloud beta workstations start \
  --project=${var.project} \
  --region=${var.region} \
  --cluster=${var.name} \
  --config=${var.name} \
  ${var.name}

gcloud beta workstations start-tcp-tunnel \
  --project=${var.project} \
  --region=${var.region} \
  --cluster=${var.name} \
  --config=${var.name} \
  --local-host-port=:${local.local_port} \
  ${var.name} 22
EOF
}

output "ssh_command" {
  value = <<EOF
ssh user@127.0.0.1 -p ${local.local_port} \
  -o StrictHostKeyChecking=no \
  -o UserKnownHostsFile=/dev/null
  EOF
}
