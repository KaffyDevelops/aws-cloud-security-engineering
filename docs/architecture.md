# Architecture

## Design Intent

The architecture is intentionally small enough to understand but structured around real cloud-security boundaries.

### Network

- one VPC across two Availability Zones
- two public subnets
- two private subnets
- Internet Gateway attached only through the public route table
- no NAT Gateway by default
- web, application and database security groups model tier-to-tier access

### Telemetry

- VPC Flow Logs record accepted and rejected network traffic into CloudWatch Logs
- CloudTrail records AWS API activity to an encrypted S3 log archive
- CloudTrail log-file validation is enabled

### Detection and posture

- GuardDuty can be enabled as a deliberate test control
- EventBridge routes GuardDuty findings to an encrypted SNS topic
- AWS Config and Security Hub are optional because they can create additional lab cost
- IAM Access Analyzer provides account-level external-access analysis

## Trust Boundaries

1. Internet to public subnet
2. web tier to application tier
3. application tier to database tier
4. AWS service APIs to security logging plane
5. security services to findings/alerting plane

No application workload is deployed in the baseline. The security groups document intended trust relationships without adding EC2/RDS cost.
