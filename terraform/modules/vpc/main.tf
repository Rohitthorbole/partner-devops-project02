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

#subnet

resource "aws_subnet" "my_public_subnet" {
  count = var.create_public_subnet ? 1 : 0
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnet_cidr.cidr_block
  availability_zone       = var.public_subnet_cidr.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-public-subnet"
  }
}

resource "aws_subnet" "my_private_subnet" {
  count = var.create_private_subnet ? 1 : 0
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet_cidr.cidr_block
  availability_zone       = var.private_subnet_cidr.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.vpc_name}-private-subnet"
  }
}

#Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = var.create_public_subnet ? 1 : 0
  subnet_id      = aws_subnet.my_public_subnet[0].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_nat_gateway" "my_nat_gateway" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.my_private_subnet[0].id
  tags = {
    Name = "${var.vpc_name}-nat-gateway"
  }
}

resource "aws_eip" "nat_eip" {
  count = var.create_nat_gateway ? 1 : 0
  vpc   = true
  tags = {
    Name = "${var.vpc_name}-nat-eip"
  }
}

resource "aws_route_table" "private_route_table" {
  count  = var.create_private_subnet ? 1 : 0
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route" "private_route" {
  count                   = var.create_private_subnet ? 1 : 0
  route_table_id          = aws_route_table.private_route_table[0].id
  destination_cidr_block  = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.my_nat_gateway[0].id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = var.create_private_subnet ? 1 : 0
  subnet_id      = aws_subnet.my_private_subnet[0].id
  route_table_id = aws_route_table.private_route_table[0].id
}