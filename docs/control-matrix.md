# Security Control Matrix

| Security outcome | Terraform implementation | Validation evidence planned |
|---|---|---|
| Limit public exposure | private subnets, no automatic public IPs | route table and subnet screenshots / CLI output |
| Enforce tier segmentation | web/app/database security groups | security group rule evidence |
| Capture API activity | multi-region CloudTrail | trail status and S3 log-object evidence |
| Protect audit logs | KMS, S3 public access block, TLS-only policy, versioning | bucket settings and encrypted object metadata |
| Capture network telemetry | VPC Flow Logs | CloudWatch log stream evidence |
| Detect external IAM access | IAM Access Analyzer | analyzer status and finding review |
| Detect suspicious activity | GuardDuty | authorised finding/test evidence |
| Route findings | EventBridge → encrypted SNS topic | event rule and target evidence |
| Monitor configuration | AWS Config | recorder status and configuration history |
| Aggregate posture findings | Security Hub | enabled standards/findings evidence |
| Validate infrastructure code | GitHub Actions, Terraform fmt/validate, TFLint | green workflow run |
