variable "environment" {
  type = string
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "chiijie-outfit-${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name        = "chiijie-outfit-${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  for_each = toset(slice(data.aws_availability_zones.available.names, 0, 2))

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, index(data.aws_availability_zones.available.names, each.key))
  availability_zone       = each.key
  map_public_ip_on_launch = true
  tags = {
    Name        = "chiijie-outfit-${var.environment}-public-${each.key}"
    Environment = var.environment
    Tier        = "public"
  }
}

resource "aws_subnet" "private" {
  for_each = toset(slice(data.aws_availability_zones.available.names, 0, 2))

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, 10 + index(data.aws_availability_zones.available.names, each.key))
  availability_zone = each.key
  tags = {
    Name        = "chiijie-outfit-${var.environment}-private-${each.key}"
    Environment = var.environment
    Tier        = "private"
  }
}

resource "aws_eip" "nat" {
  count = 1
  vpc   = true
  tags = {
    Name        = "chiijie-outfit-${var.environment}-nat-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[sort(keys(aws_subnet.public))[0]].id
  depends_on    = [aws_internet_gateway.this]
  tags = {
    Name        = "chiijie-outfit-${var.environment}-nat"
    Environment = var.environment
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  tags = {
    Name        = "chiijie-outfit-${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
  tags = {
    Name        = "chiijie-outfit-${var.environment}-private-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "vpc_cidr_block" {
  value = aws_vpc.this.cidr_block
}
