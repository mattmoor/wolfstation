# Wolfstation

This repo demonstrates a building a minimal image for using a
[Wolfi](https://wolfi.dev/os)-based image and deploying it to
[Google Cloud Workstations](https://cloud.google.com/workstations/).

### Usage

To build and deploy the basic minimal image:

```shell
terraform init
export TF_VAR_project=$(gcloud config get-value project)
terraform apply
```

This will build and deploy the image to a workstation cluster in your project,
and print commands to run to start and connect to the workstation using SSH.

### Cleanup

Cloud Workstations will stop when not being actively used, but they still
[cost money](https://cloud.google.com/workstations/) even when idle. To avoid
unnecessary costs, you can delete the cluster if you're just experimenting:

```shell
terraform destroy
```

### Adding more packages

Being minimal, this image itself is not particularly useful, but the intent
is to demonstrate a basis from which additional tooling may be installed to
build up a more complete image for your own environment.

For example, if you would like to install `gcloud` you can add the
`google-cloud-sdk` package to the package list in `main.tf`, or try it here
via:

```shell
export TF_VAR_extra_packages='["google-cloud-sdk"]'
terraform apply
```

For example, if you would like to interact with GKE, then you can add the
`gke-gcloud-auth-plugin` package (which will pull in `google-cloud-sdk` and
`kubectl`), or try it here via:

```shell
export TF_VAR_extra_packages='["gke-gcloud-auth-plugin"]'
terraform apply
```

While the image is configured to run as root to bootstrap, when you connect via
Cloud Workstations you will be logged in as `user`, and in the spirit of
minimalism and least privilege this image does not contain `sudo` or `apk`
so you will need to configure the image to have these if you would like to
extend the image.  You may also want to set up "passwordless" `sudo`.
