resource "aws_vpc" "vpc" {
  count                = "${var.enable}"
  cidr_block           = "${var.cidr}"
  enable_dns_support   = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags {
    Name        = "${var.vpc_name}-vpc"
    environment = "${var.environment}"
    depends_id  = "${var.depends_id}"
  }
}

resource "aws_route53_zone" "net0ps" {
  count = "${var.enable}"
  name  = "${var.vpc_name}-net0ps.com"

  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
  }

  comment = "Private hosted zone for ${var.environment}"

  tags {
    Name        = "${var.vpc_name}-private-zone"
    environment = "${var.environment}"
  }
}

resource "aws_route53_zone" "subdomain" {
  count   = "${var.enable * length(var.subdomain) > 0 ? 1 : 0}"
  name    = "${var.subdomain}"
  comment = "Public hosted zone for ${var.environment} subdomain"

  tags {
    Name        = "${var.vpc_name}-public-zone"
    environment = "${var.environment}"
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  count  = "${var.enable}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name        = "${var.vpc_name}-igw"
    environment = "${var.environment}"
  }
}

# NAT gateway
resource "aws_nat_gateway" "nat" {
  count         = "${var.enable}"
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${element(aws_subnet.public.*.id, var.nat_az_number)}"

  depends_on = ["aws_internet_gateway.igw", "aws_eip.nat"]

  tags {
    Name        = "${var.vpc_name}-nat-gateway"
    environment = "${var.environment}"
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  count = "${var.enable}"
  vpc   = true
}

resource "aws_default_network_acl" "acl" {
  count                  = "${var.enable}"
  default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"
  subnet_ids             = ["${aws_subnet.private.*.id}", "${aws_subnet.public.*.id}"]

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

  tags {
    Name        = "${var.vpc_name}-acl"
    environment = "${var.environment}"
  }
}

# By default nothing is exposed to the Internet
resource "aws_default_route_table" "private" {
  count                  = "${var.enable}"
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  # route = [{"cidr_block" = "0.0.0.0/0", "nat_gateway_id" = "${aws_nat_gateway.nat.id}"}]
  tags {
    Name        = "${var.vpc_name}-private-rt"
    environment = "${var.environment}"
    depends_id  = "${var.depends_id}"
  }
}

resource "aws_route" "private-nat" {
  count                  = "${var.enable}"
  route_table_id         = "${aws_default_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}

# Public routing table
resource "aws_route_table" "public" {
  # inline entries and additional atomic entries causes race condition in final routing table
  count  = "${var.enable}"
  vpc_id = "${aws_vpc.vpc.id}"

  # An example of list of maps in-lieu of https://www.terraform.io/docs/providers/aws/r/route_table.html
  #    route = [{"cidr_block" = "0.0.0.0/0", "gateway_id" = "${aws_internet_gateway.igw.id}"}]
  tags {
    Name        = "${var.vpc_name}-public-rt"
    environment = "${var.environment}"
    depends_id  = "${var.depends_id}"
  }
}

resource "aws_route" "public-igw" {
  count                  = "${var.enable}"
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

# Subnets
resource "aws_subnet" "public" {
  count                   = "${var.enable * var.replication_factor}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr, 8, count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "${var.vpc_name}-public-subnet"
    environment = "${var.environment}"
    az          = "${element(var.azs, count.index)}"
  }
}

resource "aws_subnet" "private" {
  count                   = "${var.enable * var.replication_factor}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr, 8, 100+count.index)}"
  availability_zone       = "${element(var.azs, count.index)}"
  map_public_ip_on_launch = false

  tags {
    Name        = "${var.vpc_name}-private-subnet"
    environment = "${var.environment}"
    az          = "${element(var.azs, count.index)}"
  }
}

resource "aws_route_table_association" "public" {
  count          = "${var.enable * var.replication_factor}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${var.enable * var.replication_factor}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_default_route_table.private.id}"
}

# Allow all traffic within the VPC and HTTP, HTTPS, SSH traffic from everywhere
resource "aws_default_security_group" "vpc-default-sg" {
  count  = "${var.enable}"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.vpc_name}-default-sg"
    environment = "${var.environment}"
  }
}

resource "null_resource" "dummy_dependency" {
  depends_on = ["aws_vpc.vpc", "aws_route_table.public", "aws_default_route_table.private"]
}
