locals {
  instance_count       = 1
  security_group_count = 1
  public_dns           = var.associate_public_ip_address && var.assign_eip_address && var.instance_enabled ? data.null_data_source.eip.outputs["public_dns"] : join("", aws_instance.default.*.public_dns)
}

data "aws_caller_identity" "default" {
}

data "aws_partition" "default" {
}

data "aws_subnet" "default" {
  id = var.subnet_id
}

data "aws_ami" "ami" {
  most_recent = "true"

  filter {
    name   = "name"
    values = [ var.ami ]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [ var.ami_owner ]
}



module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  attributes  = var.attributes
  delimiter   = var.delimiter
  enabled     = var.instance_enabled
  tags        = var.tags
}

resource "aws_instance" "default" {
  count                       = var.instance_count
  ami                         = data.aws_ami.ami.id
  availability_zone           = var.availability_zone
  instance_type               = var.instance_type
  ebs_optimized               = var.ebs_optimized
  disable_api_termination     = var.disable_api_termination
  user_data                   = var.user_data
  iam_instance_profile        = join("", aws_iam_instance_profile.default.*.name)
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = "terraform"
  subnet_id                   = var.subnet_id
  monitoring                  = var.monitoring
  private_ip                  = var.private_ip
  source_dest_check           = var.source_dest_check
  ipv6_address_count          = var.ipv6_address_count < 0 ? null : var.ipv6_address_count
  ipv6_addresses              = length(var.ipv6_addresses) == 0 ? null : var.ipv6_addresses

  vpc_security_group_ids = compact(
    concat(
      [
        var.create_default_security_group ? join("", aws_security_group.default.*.id) : "",
      ],
      var.security_groups
    )
  )

  provisioner "file" {
    source      = "files/${var.install_file}"
    destination = "/tmp/${var.install_file}"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file("~/.ssh/${var.key_name}.pem")
      host        = self.public_ip
    }
  }

  provisioner "file" {
    source      = "files/${var.service_file}.service"
    destination = "/tmp/${var.service_file}.service"

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file("~/.ssh/${var.key_name}.pem")
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/${var.service_file}.service /etc/systemd/system/${var.service_file}.service",
      "sudo sh /tmp/${var.install_file}",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart ${var.service_file}",
      "sudo rm /tmp/${var.install_file}",
    ]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file("~/.ssh/${var.key_name}.pem")
      host        = self.public_ip
    }
  }

  tags = module.label.tags
}

resource "aws_eip" "default" {
  network_interface = join("", aws_instance.default.*.primary_network_interface_id)
  vpc               = true
}

data "null_data_source" "eip" {
  inputs = {
    public_dns = "ec2-${replace(join("", aws_eip.default.*.public_ip), ".", "-")}.${var.region == "us-east-1" ? "compute-1" : "${var.region}.compute"}.amazonaws.com"
  }
}
