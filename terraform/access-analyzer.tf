resource "aws_accessanalyzer_analyzer" "account" {
  count = var.enable_access_analyzer ? 1 : 0

  analyzer_name = "${local.name_prefix}-access-analyzer"
  type          = "ACCOUNT"
}
