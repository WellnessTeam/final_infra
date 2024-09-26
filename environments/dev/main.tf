provider "aws" {
  region = var.region # AWS region
}

# VPC module
module "vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
}

# EC2 module
module "ec2" {
  source        = "../../modules/ec2"
  environment   = var.environment
  instance_type = var.instance_type
  subnet_ids    = module.vpc.public_subnets
  vpc_id        = module.vpc.vpc_id
  key_name      = var.key_name
}

module "rds" {
  source                = "../../modules/rds"
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnets
  db_user               = var.db_user
  db_password           = var.db_password
  ec2_security_group_id = module.ec2.ec2_sg_id
}

module "s3" {
  source      = "../../modules/s3"
  environment = var.environment
}

module "dynamodb" {
  source      = "../../modules/dynamodb"
  environment = var.environment
}

# Route 53 모듈 호출
module "route53" {
  source                = "../../modules/route53"
  environment           = var.environment
  load_balancer_dns     = module.ec2.load_balancer_dns # 로드 밸런서의 DNS 이름
  load_balancer_zone_id = module.ec2.load_balancer_zone_id
}
