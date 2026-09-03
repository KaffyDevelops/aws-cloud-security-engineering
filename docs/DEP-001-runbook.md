# DEP-001: Cost-Safe AWS Deployment Runbook

## Purpose

Deploy the validated Terraform baseline into an authorised AWS lab account while keeping cost-sensitive optional security services disabled.

The first deployment uses **AWS CloudShell** so the operator can work with temporary AWS credentials inherited from the AWS Management Console session instead of creating long-lived access keys.

## Required safety checks before deployment

- The AWS root user has MFA enabled.
- The root user is not being used for routine deployment work.
- The deployment identity is an authorised administrative or delegated lab identity.
- A low AWS cost budget and notification have been configured.
- Region is intentionally set to `eu-west-2` unless changed before deployment.
- GuardDuty, AWS Config and Security Hub remain disabled for DEP-001.

## Initial feature flags

```hcl
enable_access_analyzer = true
enable_guardduty       = false
enable_security_hub    = false
enable_config          = false
```

## Checkpoint A: Confirm the AWS identity

Open AWS CloudShell from the AWS Management Console in `eu-west-2` and run:

```bash
aws sts get-caller-identity
aws configure get region
```

Expected result:

- The identity belongs to the authorised lab account.
- The ARN does **not** identify the AWS account root user.
- The region is `eu-west-2`, or the intended alternative region is explicitly documented.

Do not publish the complete AWS account ID in portfolio evidence.

## Checkpoint B: Prepare CloudShell

AWS CLI v2 is already available in CloudShell. Install the same Terraform version used in this repository's CI workflow:

```bash
TF_VERSION="1.12.2"
mkdir -p "$HOME/bin"
curl -fsSLo /tmp/terraform.zip \
  "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
unzip -qo /tmp/terraform.zip -d "$HOME/bin"
export PATH="$HOME/bin:$PATH"
grep -qxF 'export PATH="$HOME/bin:$PATH"' "$HOME/.bashrc" || \
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
terraform version
```

Expected result: Terraform `v1.12.2` is available.

## Checkpoint C: Clone and prepare the repository

```bash
cd "$HOME"
git clone https://github.com/KaffyDevelops/aws-cloud-security-engineering.git
cd aws-cloud-security-engineering/terraform
cp terraform.tfvars.example terraform.tfvars
```

Review the local variable file:

```bash
cat terraform.tfvars
```

Confirm it contains:

```hcl
aws_region         = "eu-west-2"
project_name       = "aws-cloud-security-engineering"
environment        = "lab"
vpc_cidr           = "10.42.0.0/16"
log_retention_days = 30

enable_access_analyzer = true
enable_guardduty       = false
enable_security_hub    = false
enable_config          = false
```

`terraform.tfvars` is ignored by Git and must not be committed.

## Checkpoint D: Validate locally in CloudShell

```bash
terraform fmt -check -recursive
terraform init -input=false
terraform validate
```

Expected result:

- formatting check succeeds
- provider installation succeeds
- Terraform reports that the configuration is valid

Do not continue to apply if validation fails.

## Checkpoint E: Create the first real Terraform plan

```bash
terraform plan \
  -input=false \
  -out=dep-001.tfplan
```

Then generate a human-readable copy for private review:

```bash
terraform show -no-color dep-001.tfplan > "$HOME/dep-001-plan.txt"
```

The `.gitignore` prevents `*.tfplan` and `*.tfvars` from being committed.

## Mandatory plan review before apply

Before `terraform apply`, review the plan and confirm that it proposes only the expected baseline controls:

- VPC and subnet architecture
- route tables and Internet Gateway
- web, application and database security groups
- VPC Flow Logs and CloudWatch Logs
- CloudTrail
- security-log S3 bucket
- KMS key and alias
- IAM roles required by logging services
- IAM Access Analyzer

The plan must **not** enable:

- GuardDuty
- AWS Config
- Security Hub
- NAT Gateway
- EC2 workloads merely for portfolio screenshots
- RDS workloads merely for portfolio screenshots

## Stop point

DEP-001 deliberately stops here for peer review before the first apply.

Do not run `terraform apply dep-001.tfplan` until the plan has been reviewed for unexpected resources, permissions, cost-sensitive services and identifiers that should not become public evidence.

## Evidence to capture at this stage

Capture sanitised evidence of:

1. Terraform version
2. successful `terraform validate`
3. the Terraform plan summary, for example the number of resources to add/change/destroy
4. the feature flags showing optional services disabled

Do not publish:

- AWS account ID
- access tokens or session credentials
- full sensitive ARNs where unnecessary
- Terraform state
- `terraform.tfvars`
- complete plan files before review and redaction

## References

- AWS CloudShell uses the AWS credentials associated with the console session and supports temporary credentials.
- AWS recommends using temporary credentials and avoiding root-user access keys.
- AWS Budgets should be configured before lab deployment to monitor spend. Budget alerts are monitoring controls, not a hard spending cap.

## Disclosure

> This is an independently built AWS cloud security portfolio lab deployed only in an authorised AWS account. It is not presented as production employment or client experience.
