# Threat Model

## Assets

- AWS account control plane
- IAM identities and roles
- VPC network boundaries
- security logs
- KMS key material
- future application and database workloads

## Key Threats

| Threat | Security concern | Control in this project |
|---|---|---|
| Excessive public exposure | Unnecessary internet reachability | private subnets, explicit security groups, no public IP assignment by default |
| Lateral movement | Compromise crossing tiers | web → app → database SG references |
| Missing API audit trail | Actions cannot be reconstructed | multi-region CloudTrail |
| Audit-log tampering | Evidence integrity reduced | S3 controls, KMS, versioning, CloudTrail log-file validation |
| Suspicious network activity | Network behaviour invisible | VPC Flow Logs |
| Credential/resource exposure | External access not recognised | IAM Access Analyzer |
| Malicious AWS activity | Weak threat detection | optional GuardDuty |
| Configuration drift | Insecure changes persist | optional AWS Config and Security Hub |
| CI credential theft | Long-lived AWS secrets exposed in GitHub | project does not require static AWS credentials in CI |

## Explicit Limitations

- This is a single-account portfolio architecture, not an AWS Organizations multi-account landing zone.
- The baseline does not deploy production workloads.
- It does not claim enterprise-scale centralised logging.
- GuardDuty, AWS Config and Security Hub require deliberate enablement and runtime validation.
