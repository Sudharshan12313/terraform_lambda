variable "lambda_services" {
  description = "List of microservices"
  type        = map(object({
    ecr_image_uri = string
    memory_size   = number
    timeout       = number
  }))
}
