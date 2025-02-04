output "log_groups" {
  value = { for k, v in aws_cloudwatch_log_group.lambda_logs : k => v.name }
}
