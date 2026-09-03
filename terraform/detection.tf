resource "aws_guardduty_detector" "main" {
  count = var.enable_guardduty ? 1 : 0

  enable = true
}

resource "aws_securityhub_account" "main" {
  count = var.enable_security_hub ? 1 : 0
}

resource "aws_sns_topic" "security_findings" {
  name              = "${local.name_prefix}-security-findings"
  kms_master_key_id = "alias/aws/sns"
}

data "aws_iam_policy_document" "security_findings_topic" {
  statement {
    sid    = "AllowEventBridgePublish"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.security_findings.arn]
  }
}

resource "aws_sns_topic_policy" "security_findings" {
  arn    = aws_sns_topic.security_findings.arn
  policy = data.aws_iam_policy_document.security_findings_topic.json
}

resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  name        = "${local.name_prefix}-guardduty-findings"
  description = "Routes GuardDuty findings to the security findings SNS topic"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
  })
}

resource "aws_cloudwatch_event_target" "guardduty_to_sns" {
  rule      = aws_cloudwatch_event_rule.guardduty_findings.name
  target_id = "SendToSecurityFindingsTopic"
  arn       = aws_sns_topic.security_findings.arn
}
