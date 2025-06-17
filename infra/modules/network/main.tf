resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.name}-vpc"
  })
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.name}-public-${count.index}"
    Tier = "public"
  })
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = false
  tags = merge(var.tags, {
    Name = "${var.name}-private-${count.index}"
    Tier = "private"
  })
}

# Database subnet group for RDS
resource "aws_db_subnet_group" "database" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = merge(var.tags, {
    Name = "${var.name}-db-subnet-group"
  })
}

# Security group for RDS
resource "aws_security_group" "database" {
  name        = "${var.name}-db-sg"
  description = "Security group for RDS database"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow PostgreSQL traffic from within VPC"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.name}-db-sg"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, { Name = "${var.name}-igw" })
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  tags = merge(var.tags, { Name = "${var.name}-nat" })
}

resource "aws_eip" "nat" {
  vpc = true
  tags = merge(var.tags, { Name = "${var.name}-eip-nat" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, { Name = "${var.name}-public-rt" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}
