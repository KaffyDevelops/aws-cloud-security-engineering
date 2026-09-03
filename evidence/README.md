# Evidence Register

Runtime evidence belongs here only after the Terraform is deployed and validated in an authorised AWS lab account.

Suggested structure:

```text
evidence/
├── VAL-001-network-segmentation/
├── VAL-002-flow-logs/
├── VAL-003-cloudtrail/
├── VAL-004-log-protection/
├── VAL-005-access-analyzer/
├── VAL-006-guardduty/
├── VAL-007-config-security-hub/
└── VAL-008-teardown/
```

Each evidence folder should contain a short README stating:

- date/time
- control tested
- expected result
- actual result
- evidence files
- findings
- remediation or decision
- redaction notes

Do not publish access keys, session tokens, unnecessary AWS account identifiers or private production data.
