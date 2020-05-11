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
  source        = "../../modules/vpc"
  security_group_ids = module.httpbin.security_group_ids
  instance_id   = module.httpbin.instance_id
}

module "httpbin" {
  source        = "../../modules/ec2"
  region        = "us-east-1"
  name          = "httpbin"
  subnet_id     = module.vpc.subnet_id
  vpc_id        = module.vpc.vpc_id

  key_name      = "terraform"

  install_file  = "install_docker.sh"
  service_file  = "httpbin"
}

