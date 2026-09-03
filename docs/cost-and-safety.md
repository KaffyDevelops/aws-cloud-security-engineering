# Cost and Safety Notes

This repository contains AWS controls that may generate charges.

## Baseline choices

- **No NAT Gateway:** avoids a common recurring lab charge.
- **No EC2 or RDS:** the baseline models security boundaries without running compute/database workloads.
- **CloudWatch Logs / S3 / KMS / CloudTrail:** may incur usage charges depending on event volume and region.

## Optional controls disabled by default

- GuardDuty
- AWS Config
- Security Hub

Enable them only for a planned validation window, collect evidence, then disable or destroy resources when finished.

## Before apply

1. Confirm the AWS account is a dedicated authorised lab environment.
2. Review the selected region.
3. Review the Terraform plan line by line.
4. Check AWS pricing for enabled services.
5. Set a budget/alarm in AWS Billing separately from this repository.
6. Never apply using a production account merely for portfolio evidence.

## Teardown

Run `terraform destroy` after evidence collection unless there is a deliberate reason to keep the lab.
