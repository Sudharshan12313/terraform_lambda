/*# ------------------------------
# VPC Outputs
# ------------------------------
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}
# ------------------------------
# ECR Outputs
# ------------------------------
output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = module.ecr.repo_url
}

 ------------------------------
# LAMBDA Outputs
# ------------------------------
output "lambda_functions" {
  description = "Lambda Function Output"
  value       = module.lambda.lambda_functions
}

output "lambda_functions" {
  value = module.lambda.lambda_functions
}

output "cloudwatch_log_groups" {
  value = module.cloudwatch.log_groups
}

*/
