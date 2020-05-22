/**
 * # Comtravo's legacy Terraform AWS VPC module
 * # Do not use this legacy module
 *
 */



resource "aws_vpc" "vpc" {
  count                = local.enable_count
  cidr_block           = var.cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name        = "${var.vpc_name}-vpc"
    environment = var.environment
    depends_id  = var.depends_id
  }
}

resource "aws_route53_zone" "net0ps" {
  count = local.enable_count
  name  = "${var.vpc_name}-net0ps.com"

  vpc {
    vpc_id = aws_vpc.vpc[0].id
  }

  comment = "Private hosted zone for ${var.environment}"

  tags = {
    Name        = "${var.vpc_name}-private-zone"
    environment = var.environment
  }
}

resource "aws_route53_zone" "subdomain" {
  count   = var.enable && var.subdomain != "" ? 1 : 0
  name    = var.subdomain
  comment = "Public hosted zone for ${var.environment} subdomain"

  tags = {
    Name        = "${var.vpc_name}-public-zone"
    environment = var.environment
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  count  = local.enable_count
  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name        = "${var.vpc_name}-igw"
    environment = var.environment
  }
}

# NAT gateway
resource "aws_nat_gateway" "nat" {
  count         = local.enable_count
  allocation_id = aws_eip.nat[0].id
  subnet_id     = element(aws_subnet.public.*.id, var.nat_az_number)

  depends_on = [
    aws_internet_gateway.igw,
    aws_eip.nat,
  ]

  tags = {
    Name        = "${var.vpc_name}-nat-gateway"
    environment = var.environment
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  count = local.enable_count
  vpc   = true
}

resource "aws_default_network_acl" "acl" {
  count                  = local.enable_count
  default_network_acl_id = aws_vpc.vpc[0].default_network_acl_id
  subnet_ids             = concat(aws_subnet.private.*.id, aws_subnet.public.*.id)

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${var.vpc_name}-acl"
    environment = var.environment
  }
}

resource "aws_default_route_table" "private" {
  count                  = local.enable_count
  default_route_table_id = aws_vpc.vpc[0].default_route_table_id

  tags = {
    Name        = "${var.vpc_name}-private-rt"
    environment = var.environment
    depends_id  = var.depends_id
  }
}

resource "aws_route" "private-nat" {
  count                  = local.enable_count
  route_table_id         = aws_default_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

# Public routing table
resource "aws_route_table" "public" {
  # inline entries and additional atomic entries causes race condition in final routing table
  count  = local.enable_count
  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name        = "${var.vpc_name}-public-rt"
    environment = var.environment
    depends_id  = var.depends_id
  }
}

resource "aws_route" "public-igw" {
  count                  = local.enable_count
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

# Subnets
resource "aws_subnet" "public" {
  count                   = local.replication_count
  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = cidrsubnet(var.cidr, 8, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.vpc_name}-public-subnet"
    environment = var.environment
    az          = element(var.azs, count.index)
  }
}

resource "aws_subnet" "private" {
  count                   = local.replication_count
  vpc_id                  = aws_vpc.vpc[0].id
  cidr_block              = cidrsubnet(var.cidr, 8, 100 + count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.vpc_name}-private-subnet"
    environment = var.environment
    az          = element(var.azs, count.index)
  }
}

resource "aws_route_table_association" "public" {
  count          = local.replication_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}

resource "aws_route_table_association" "private" {
  count          = local.replication_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_default_route_table.private[0].id
}

# Allow all traffic within the VPC
resource "aws_default_security_group" "vpc-default-sg" {
  count  = local.enable_count
  vpc_id = aws_vpc.vpc[0].id

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-default-sg"
    environment = var.environment
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = [
    aws_vpc.vpc,
    aws_route_table.public,
    aws_default_route_table.private,
  ]
}
