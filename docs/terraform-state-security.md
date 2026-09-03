# Terraform State Security

Terraform state can contain infrastructure identifiers and, depending on the resources managed, potentially sensitive values. It should not be committed to GitHub.

## Repository controls

The `.gitignore` excludes:

- `.terraform/`
- `*.tfstate`
- `*.tfstate.*`
- plan files
- ordinary `.tfvars` files

## Local lab phase

Local state can be used temporarily during a controlled lab, provided the machine and working directory are protected and the state is deleted securely when no longer needed.

## Remote-state direction

`terraform/backend.tf.example` documents an S3 backend pattern with encryption and state locking. A dedicated state bucket should be bootstrapped separately rather than created by the same state it is meant to protect.

For a stronger production design, also consider:

- dedicated state bucket
- S3 versioning
- public-access blocking
- KMS encryption
- least-privilege access to state
- CloudTrail monitoring of state-bucket API activity
- separation between deployment and administrative roles
