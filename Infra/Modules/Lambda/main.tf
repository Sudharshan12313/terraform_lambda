resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  description = "Allow Lambda to access application microservices"
  vpc_id      = var.vpc_id

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow traffic on ports 3000 and 3001
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3001
    to_port     = 3001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# Lambda Function Setup
resource "aws_lambda_function" "container_lambda" {
  for_each      = var.lambda_services
  function_name = each.key
  role          = var.lambda_role_arn
  package_type  = "Image"
  image_uri     = each.value.ecr_image_uri
  timeout       = each.value.timeout
  memory_size   = each.value.memory_size

  environment {
    variables = {
      ENV = "dev"
    }
  }
}

# API Gateway Setup
resource "aws_apigatewayv2_api" "lambda_api" {
  name          = "LambdaAPI"
  protocol_type = "HTTP"
}


resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "appointments"
  principal     = "apigateway.amazonaws.com"

  # Allow API Gateway to invoke this Lambda function
  source_arn = "${aws_apigatewayv2_api.lambda_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.lambda_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = "arn:aws:lambda:us-west-2:183114607892:function:appointments"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "lambda_route_health" {
  api_id    = aws_apigatewayv2_api.lambda_api.id
  route_key = "GET /health"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "lambda_stage" {
  api_id      = aws_apigatewayv2_api.lambda_api.id
  name        = "dev"
  auto_deploy = true

  default_route_settings {
    logging_level = "INFO"
    data_trace_enabled = true
    throttling_rate_limit = 10000  # Set your rate limit here (RPS)
    throttling_burst_limit = 5000  # Set your burst limit here
  }

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_log.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

resource "aws_cloudwatch_log_group" "api_gw_log" {
  name = "/aws/apigateway/lambda-api-logs"
  retention_in_days = 30
}

# Output the API URL for access
output "api_url" {
  value = "https://${aws_apigatewayv2_api.lambda_api.id}.execute-api.us-west-2.amazonaws.com/dev"
}

data "aws_region" "current" {}

output "api_gateway_arn" {
  value = aws_apigatewayv2_api.lambda_api.execution_arn
}

