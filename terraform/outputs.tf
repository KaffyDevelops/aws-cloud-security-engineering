output "vpc_id" {
  description = "VPC ID for the lab environment."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "cloudtrail_name" {
  description = "CloudTrail trail name."
  value       = aws_cloudtrail.security.name
}

output "security_log_bucket" {
  description = "Encrypted S3 bucket used for CloudTrail and optional AWS Config delivery."
  value       = aws_s3_bucket.security_logs.id
}

output "vpc_flow_log_group" {
  description = "CloudWatch Log Group receiving VPC Flow Logs."
  value       = aws_cloudwatch_log_group.vpc_flow_logs.name
}

output "security_findings_topic_arn" {
  description = "SNS topic for routed security findings."
  value       = aws_sns_topic.security_findings.arn
}

output "cost_sensitive_features" {
  description = "Current state of optional cost-sensitive controls."
  value = {
    guardduty    = var.enable_guardduty
    security_hub = var.enable_security_hub
    aws_config   = var.enable_config
  }
}
