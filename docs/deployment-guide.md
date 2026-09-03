# Deployment Guide

## Prerequisites

- authorised AWS lab account
- Terraform >= 1.6
- AWS CLI or another supported AWS provider authentication mechanism
- IAM permissions sufficient to create the resources in the plan

## Authentication

Prefer short-lived credentials, IAM Identity Center, or an assumed role. Do not commit access keys to this repository.

## Sequence

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
terraform show tfplan
terraform apply tfplan
```

## Optional security controls

Enable one cost-sensitive service at a time, for example:

```hcl
enable_guardduty    = true
enable_security_hub = false
enable_config       = false
```

Collect validation evidence before enabling the next control.

## Teardown

```bash
terraform destroy
```

Confirm that the S3 log archive and all optional controls are removed if the lab is no longer required.
