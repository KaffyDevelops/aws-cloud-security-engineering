locals {
  name_prefix = "${var.project_name}-${var.environment}"

  security_log_bucket_name = lower(
    "${var.project_name}-${data.aws_caller_identity.current.account_id}-${var.aws_region}-logs"
  )

  trail_name = "${local.name_prefix}-trail"

  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
}
