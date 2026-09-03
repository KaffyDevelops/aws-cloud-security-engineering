data "aws_iam_policy_document" "config_assume_role" {
  count = var.enable_config ? 1 : 0

  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "config" {
  count = var.enable_config ? 1 : 0

  name               = "${local.name_prefix}-config-role"
  assume_role_policy = data.aws_iam_policy_document.config_assume_role[0].json
}

resource "aws_iam_role_policy_attachment" "config" {
  count = var.enable_config ? 1 : 0

  role       = aws_iam_role.config[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_config_configuration_recorder" "main" {
  count = var.enable_config ? 1 : 0

  name     = "${local.name_prefix}-recorder"
  role_arn = aws_iam_role.config[0].arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "main" {
  count = var.enable_config ? 1 : 0

  name           = "${local.name_prefix}-delivery"
  s3_bucket_name = aws_s3_bucket.security_logs.id
  s3_kms_key_arn = aws_kms_key.security_logs.arn

  depends_on = [aws_s3_bucket_policy.security_logs]
}

resource "aws_config_configuration_recorder_status" "main" {
  count = var.enable_config ? 1 : 0

  name       = aws_config_configuration_recorder.main[0].name
  is_enabled = true

  depends_on = [aws_config_delivery_channel.main]
}
