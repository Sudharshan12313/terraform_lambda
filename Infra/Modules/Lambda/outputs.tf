output "lambda_functions" {
  value = { for k, v in aws_lambda_function.container_lambda : k => v.arn }
}
