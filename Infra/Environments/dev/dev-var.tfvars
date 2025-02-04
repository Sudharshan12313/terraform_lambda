aws_region = "us-west-2"
vpc_cidr = "10.0.0.0/16"
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-west-2a", "us-west-2b"]
security_groups = ["sg-09c3b12ec1c311254"]
repo_name = "my-app-repo"
lambda_services = {
  appointments = {
    ecr_image_uri = "183114607892.dkr.ecr.us-west-2.amazonaws.com/appointment-service:latest"
    memory_size   = 512
    timeout       = 600
  }
  patients = {
    ecr_image_uri = "183114607892.dkr.ecr.us-west-2.amazonaws.com/patient-service:latest"
    memory_size   = 512
    timeout       = 600
  }
}
