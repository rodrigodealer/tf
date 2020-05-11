locals {
  additional_ips_count = var.associate_public_ip_address && var.instance_enabled && var.additional_ips_count > 0 ? var.additional_ips_count : 0
}

resource "aws_network_interface" "additional" {
  count     = local.additional_ips_count
  subnet_id = aws_subnet.main.id

  security_groups = var.security_group_ids

}

resource "aws_network_interface_attachment" "additional" {
  count                = local.additional_ips_count
  instance_id          = var.instance_id
  network_interface_id = aws_network_interface.additional[count.index].id
  device_index         = 1 + count.index
}

resource "aws_eip" "additional" {
  count             = local.additional_ips_count
  vpc               = true
  network_interface = aws_network_interface.additional[count.index].id
}
