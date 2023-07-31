/*
Copyright 2023 Chainguard, Inc.
SPDX-License-Identifier: Apache-2.0
*/

output "ssh_command" {
  value = <<EOF
gcloud beta workstations start \
    --project=${var.project} \
    --region=${var.region} \
    --cluster=${var.name} \
    --config=${var.name} \
    ${var.name}

gcloud beta workstations ssh \
    --project=${var.project} \
    --region=${var.region} \
    --cluster=${var.name} \
    --config=${var.name} \
    ${var.name}
  EOF
}

output "stop_command" {
  value = <<EOF
gcloud beta workstations stop \
    --project=${var.project} \
    --region=${var.region} \
    --cluster=${var.name} \
    --config=${var.name} \
    ${var.name}
EOF
}
