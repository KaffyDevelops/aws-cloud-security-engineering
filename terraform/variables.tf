variable "aws_region" {
  description = "AWS region for the lab environment."
  type        = string
  default     = "eu-west-2"
}

variable "project_name" {
  description = "Short project identifier used in resource names and tags."
  type        = string
  default     = "aws-cloud-security-engineering"
}

variable "environment" {
  description = "Environment label."
  type        = string
  default     = "lab"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC."
  type        = string
  default     = "10.42.0.0/16"
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch and S3 lab security logs."
  type        = number
  default     = 30

  validation {
    condition     = var.log_retention_days >= 7 && var.log_retention_days <= 365
    error_message = "log_retention_days must be between 7 and 365 for this lab."
  }
}

variable "enable_access_analyzer" {
  description = "Enable account-level IAM Access Analyzer."
  type        = bool
  default     = true
}

variable "enable_guardduty" {
  description = "Enable GuardDuty. This can incur charges."
  type        = bool
  default     = false
}

variable "enable_security_hub" {
  description = "Enable Security Hub CSPM. This can incur charges."
  type        = bool
  default     = false
}

variable "enable_config" {
  description = "Enable AWS Config recorder and delivery. This can incur charges."
  type        = bool
  default     = false
}
