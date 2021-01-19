# Deploying a simple webserver on OVHcloud

This tutorial shows how to deploy a simple webserver on the OVHcloud using `terraform` and the OpenStack provider.

A few key pieces of information:
- We will deploy `out-of-the-box` NGINX servers, with no specific configuration
- We will use `terraform` in version `v0.12.30` (since the provider has not been ported to `v0.13` yet: https://github.com/terraform-provider-openstack/terraform-provider-openstack)
- We use a local `terraform` remote state

### Prerequisites (things you need before starting the tutorial):
- An OVHcloud account, and a project
- An OpenStack user (https://docs.ovh.com/us/en/public-cloud/creation-and-deletion-of-openstack-user/)
- An SSH key (https://docs.ovh.com/us/en/public-cloud/create-ssh-keys/)
- A basic understanding of `terraform`

### Setting credentials for `terraform` (and `openstack`)

1. Download the `openrc.sh` for your OpenStack user

The OpenStack interface on OVHcloud let you download an executable that sets several environment variables:

![ovh-cloud-dl-openrc.png](screenshots/ovh-cloud-dl-openrc.png) 

![oveh-cloud-choose-region.png](screenshots/oveh-cloud-choose-region.png)

To use it simply execute `source openrc.sh` (this will ask for your OpenStack user password).

2. Export your OpenStack user credentials as `terraform` environment variable.

In this tutorial we will use those credentials directly in the `terraform` code, instead having them clear in the code (and risking publishing it) it is better to set them as environment variables.

```
export TF_VAR_open_stack_user_name="user-D4MJqEfed3EA"
export TF_VAR_open_stack_password="XXXXXXXXXXXXXXXXXXXXXXXX"
```

## 1) Simple NGINX on a public instance

Go to the folder `1-public-nginx` and execute:

```
terraform init
terraform apply
```
