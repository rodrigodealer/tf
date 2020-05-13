output "elb_dns" {
  description = "DNS name for ELB"
  value       = aws_elb.main.dns_name
}

output "elb_name" {
  description = "Name for ELB"
  value       = aws_elb.main.name
}