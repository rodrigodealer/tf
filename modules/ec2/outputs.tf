output "private_ip" {
  description = "Private IP of instance"
  value       = join("", aws_instance.default.*.private_ip)
}

output "private_dns" {
  description = "Private DNS of instance"
  value       = join("", aws_instance.default.*.private_dns)
}

output "public_dns" {
  description = "Public DNS of instance"
  value       = join("", aws_instance.default.*.public_dns)
}

output "id" {
  description = "Disambiguated ID of the instance"
  value       = join("", aws_instance.default.*.id)
}

output "name" {
  description = "Instance name"
  value       = module.label.id
}

output "ssh_key_pair" {
  description = "Name of the SSH key pair provisioned on the instance"
  value       = var.ssh_key_pair
}

output "security_group_ids" {
  description = "IDs on the AWS Security Groups associated with the instance"
  value = compact(
    concat(
      [var.create_default_security_group == true ? join("", aws_security_group.default.*.id) : ""],
      var.security_groups
    )
  )
}

output "security_groups" {
  description = "List of security groups"
  value       = aws_security_group.default.*.id
}

output "instance_id" {
  description = "IDs on the AWS EC2 Instances"
  value       = join("", aws_instance.default.*.id)
}

output "instance_ids" {
  description = "IDs on the AWS EC2 Instances"
  value       = aws_instance.default.*.id
}

output "instances_dns" {
  description = "Public DNS on the AWS EC2 Instances"
  value       = aws_instance.default.*.public_dns
}

output "role" {
  description = "Name of AWS IAM Role associated with the instance"
  value       = join("", aws_iam_role.default.*.name)
}

output "alarm" {
  description = "CloudWatch Alarm ID"
  value       = join("", aws_cloudwatch_metric_alarm.default.*.id)
}

output "primary_network_interface_id" {
  description = "ID of the instance's primary network interface"
  value       = join("", aws_instance.default.*.primary_network_interface_id)
}