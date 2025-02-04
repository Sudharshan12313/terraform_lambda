resource "aws_cloudwatch_log_group" "lambda_logs" {
  for_each = var.lambda_services
  name     = "/aws/lambda/${each.key}"
  retention_in_days = 7
}
