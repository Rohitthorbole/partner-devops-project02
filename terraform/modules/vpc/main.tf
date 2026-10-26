#VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

#Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# subnets
resource "aws_subnet" "my_public_subnet" {
  for_each                = { for idx, s in var.public_subnet : idx => s }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-${each.value.availability_zone}-${each.key}"
  }
}

resource "aws_subnet" "my_private_subnet" {
  for_each                = { for idx, s in var.private_subnet : idx => s }
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-private-${each.value.availability_zone}-${each.key}"
  }
}

# route tables
resource "aws_route_table" "public_route_table" {
  count  = length(var.public_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route" "public_route" {
  count                  = length(var.public_subnet) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each       = aws_subnet.my_public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table[0].id
}

resource "aws_eip" "nat_eip" {
  count  = var.create_nat_gateway ? 1 : 0
  domain = "vpc"
  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "my_nat_gateway" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id

  # NAT Gateway must be in a public subnet
  subnet_id = values(aws_subnet.my_public_subnet)[0].id

  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.my_igw]

  lifecycle {
    precondition {
      condition     = length(var.public_subnet) > 0
      error_message = "At least one public subnet is required when creating a NAT Gateway."
    }
  }
}

resource "aws_route_table" "private_route_table" {
  count  = length(var.private_subnet) > 0 ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route" "private_route" {
  count = (
    var.create_nat_gateway &&
    length(var.private_subnet) > 0
  ) ? 1 : 0

  route_table_id         = aws_route_table.private_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.my_nat_gateway[0].id
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each       = aws_subnet.my_private_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table[0].id
}
