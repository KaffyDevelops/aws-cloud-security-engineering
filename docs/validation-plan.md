# Validation Plan

A Terraform resource existing in code is not enough to claim the control is working. Runtime evidence should validate each objective.

## VAL-001 Network segmentation

Confirm:
- public and private subnet route differences
- private subnets have no direct internet route
- application SG accepts traffic only from web SG on the documented port
- database SG accepts traffic only from application SG on PostgreSQL port

## VAL-002 VPC Flow Logs

Confirm:
- flow log status is ACTIVE
- CloudWatch Log Group receives records
- sample records contain expected source/destination/action fields

## VAL-003 CloudTrail

Confirm:
- multi-region trail is logging
- global service events are included
- log-file validation is enabled
- objects arrive in the encrypted S3 bucket

## VAL-004 Audit-log protection

Confirm:
- S3 public access block is enabled
- default encryption uses the project KMS key
- versioning is enabled
- insecure transport is denied

## VAL-005 IAM Access Analyzer

Confirm:
- account analyzer exists
- findings are reviewed and documented, including no-finding outcomes

## VAL-006 GuardDuty

When deliberately enabled:
- confirm detector status
- generate or use an AWS-supported safe test finding
- verify EventBridge routing to the SNS target
- document finding triage

## VAL-007 AWS Config / Security Hub

When deliberately enabled:
- verify recorder/service state
- capture a sample posture/configuration finding
- document the remediation decision

## VAL-008 Teardown

Confirm:
- `terraform destroy` completes
- no unexpected project resources remain
- evidence does not contain credentials or unnecessary account identifiers
