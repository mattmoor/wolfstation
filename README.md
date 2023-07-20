# Chainguard Images Template

This repo provides a basic template for building a Wolfi-based image using the
[terraform provider for `apko`](https://github.com/chainguard-dev/terraform-provider-apko) via our [apko publisher module](https://github.com/chainguard-dev/terraform-publisher-apko/tree/main).

After [creating your own repo from this
template](https://github.com/chainguard-images/template/generate), edit
`apko.yaml` to add or remove whatever packages you need.  You can also add
logic to sign/attest properties of the image in `main.tf`.
