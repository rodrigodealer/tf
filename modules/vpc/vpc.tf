resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_vpc" "main" {
  cidr_block            = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "main" {
  vpc_id                    = aws_vpc.main.id
  cidr_block                = var.vpc_cidr

  map_public_ip_on_launch   = true

  depends_on = [
      aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.route-table.id
}