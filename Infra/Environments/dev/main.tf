module "vpc" {
  source              = "../../Modules/VPC"
  vpc_cidr            = var.vpc_cidr
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  availability_zones  = var.availability_zones
}

module "iam" {
  source = "../../modules/iam"
}

module "lambda" {
  source         = "../../modules/lambda"
  lambda_services = var.lambda_services
  lambda_role_arn = module.iam.lambda_role_arn
  private_subnet_ids = module.vpc.private_subnets
  vpc_id           = module.vpc.vpc_id
}

module "cloudwatch" {
  source          = "../../modules/cloudwatch"
  lambda_services = var.lambda_services
}
