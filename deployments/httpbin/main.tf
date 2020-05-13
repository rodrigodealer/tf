provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-test"
    key    = "production"
    region = "us-east-1"
  }
}

module "vpc" {
  source             = "../../modules/vpc"
  security_group_ids = module.httpbin.security_group_ids
  instance_id        = module.httpbin.instance_id
}

module "httpbin" {
  source         = "../../modules/ec2"
  region         = "us-east-1"
  name           = "httpbin"
  subnet_id      = module.vpc.subnet_id
  vpc_id         = module.vpc.vpc_id
  instance_count = 2
  key_name       = "terraform"

  install_file = "install_docker.sh"
  service_file = "httpbin"
}

module "elb" {
  source        = "../../modules/elb"
  region        = "us-east-1a"
  instance_port = 80
  lb_port       = 80
  timeout       = 3
  target        = "HTTP:80/"
  lb_name       = "httpbin"

  subnet_id       = module.vpc.subnet_id
  instances       = module.httpbin.instance_ids
  security_groups = module.httpbin.security_groups
}
