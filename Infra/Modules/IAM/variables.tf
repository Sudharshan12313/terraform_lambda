variable "lambda_role" {
  description = "Name of the IAM role for EKS Node group"
  type        = string
  default     = "lambda_execution_role"
}
