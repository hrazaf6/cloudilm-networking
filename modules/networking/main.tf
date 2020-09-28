resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    managedby = var.managedby
    Name      = format("%s-VPC", var.environment)
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    managedby = var.managedby
    Name      = format("%s-VPC", var.environment)
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.this.id
  availability_zone = "us-east-1a"
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  tags = {
    managedby = var.managedby
    VPC       = format("%s-VPC", var.environment)
    Name      = format("public subnet - %d - %s", count.index, var.environment)
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  availability_zone = "us-east-1b"
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, length(var.public_subnets)+count.index)
  tags = {
    managedby = var.managedby
    VPC       = format("%s-VPC", var.environment)
    Name      = format("private subnet - %d - %s", count.index, var.environment)
  }
}

resource "aws_eip" "this" {
  vpc = true
  tags = {
    managedby = var.managedby
    VPC       = format("%s-VPC", var.environment)
    Name      = "NAT Gateway"
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public_subnets[0].id
  tags = {
    managedby = var.managedby
    VPC       = format("%s-VPC", var.environment)
    Name      = "NAT Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    managedby = var.managedby
    VPC       = format("%s-VPC", var.environment)
    Name      = "Public Route Table"
  }
}

resource "aws_route_table_association" "public_subnets" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    managedby = var.managedby
    VPC       = format("%s-VPC", var.environment)
    Name      = "Private Route Table"
  }
}

resource "aws_route_table_association" "subnet3" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}


