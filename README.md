# Wolfstation

This repo demonstrates a minimal image for using a Wolfi-based image with
Google Cloud Workstations.

Being minimal, this image itself is not particularly useful, but the intent
is to demonstrate a basis from which additional tooling may be installed to
build up a more complete image for your own environment.

For example, if you would like to install `gcloud` you can add the
`google-cloud-sdk` package to the package list in `main.tf`, or try it here
via:

```shell
terraform init
export TF_VAR_target_repository=ghcr.io/${USER}/wolfstation
export TF_VAR_extra_packages='["google-cloud-sdk"]'
terraform apply
```

For example, if you would like to interact with GKE, then you can add the
`gke-gcloud-auth-plugin` package (which will pull in `google-cloud-sdk` and
`kubectl`), or try it here via:

```shell
terraform init
export TF_VAR_target_repository=ghcr.io/${USER}/wolfstation
export TF_VAR_extra_packages='["gke-gcloud-auth-plugin"]'
terraform apply
```

While the image is configured to run as root to bootstrap, when you connect via
Cloud Workstations you will be logged in as `user`, and in the spirit of
minimalism and least privilege this image does not contain `sudo` or `apk`
so you will need to configure the image to have these if you would like to
extend the image.  You may also want to set up "passwordless" `sudo`.
