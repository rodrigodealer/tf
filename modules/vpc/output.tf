output "subnet_id" {
  description = "Subnet id"
  value       = aws_subnet.main.id
}

output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "additional_eni_ids" {
  description = "Map of ENI to EIP"
  value = zipmap(
    aws_network_interface.additional.*.id,
    aws_eip.additional.*.public_ip
  )
}