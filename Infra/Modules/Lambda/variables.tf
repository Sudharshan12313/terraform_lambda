variable "lambda_services" {
  description = "List of microservices with configurations"
  type        = map(object({
    ecr_image_uri = string
    memory_size   = number
    timeout       = number
  }))
}

variable "lambda_role_arn" {
  description = "IAM Role ARN for Lambda"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}


variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}