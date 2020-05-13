output "elb_dns" {
  description = "DNS name for ELB"
  value       = module.elb.elb_dns
}

output "elb_name" {
  description = "Name for ELB"
  value       = module.elb.elb_name
}

output "public_dns" {
  description = "Public DNS of instance"
  value       = module.httpbin.public_dns
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = module.vpc.vpc_cidr
}

output "instances_dns" {
  description = "IDs on the AWS EC2 Instances"
  value       = module.httpbin.instances_dns
}