# CI Authentication Strategy

The initial GitHub Actions workflow performs static Terraform quality checks only and does **not** authenticate to AWS.

That is deliberate. No AWS access key or secret key is required for formatting, initialisation without a backend, validation or TFLint.

## Future deployment approach

If automated `terraform plan` or deployment is introduced, prefer GitHub Actions OpenID Connect (OIDC) with an AWS IAM role rather than long-lived repository secrets.

The trust policy should be constrained by:

- the specific GitHub repository
- the intended branch or environment
- the GitHub OIDC provider audience
- least-privilege IAM permissions for the deployment role

The deployment role should not be an administrator merely because Terraform is being used.

## Evidence goal

A future validation should demonstrate:

**GitHub workflow → OIDC token → AWS role assumption → least-privilege Terraform plan**

without storing AWS access keys in GitHub.
