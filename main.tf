locals {
  default_tags = {
    environment = "${terraform.workspace}"
  }
}

resource "aws_vpc" "vpc" {
  count                            = "${var.enable}"
  cidr_block                       = "${var.cidr}"
  enable_dns_support               = "${var.enable_dns_support}"
  enable_dns_hostnames             = "${var.enable_dns_hostnames}"
  assign_generated_ipv6_cidr_block = "${var.assign_generated_ipv6_cidr_block}"

  tags = "${merge(map("Name", format("%s", var.vpc_name)), var.tags, local.default_tags)}"
}

resource "aws_route53_zone" "net0ps" {
  count = "${var.enable}"
  name  = "${var.vpc_name}-net0ps.com"

  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
  }

  comment = "Private hosted zone for ${terraform.workspace}"
  tags    = "${merge(map("Name", "${var.vpc_name}-private-zone"), var.tags, local.default_tags)}"
}

resource "aws_route53_zone" "subdomain" {
  count   = "${var.enable && var.subdomain != "" ? 1 : 0}"
  name    = "${var.subdomain}"
  comment = "Public hosted zone for ${terraform.workspace} subdomain"

  tags = "${merge(map("Name", "${var.vpc_name}-public-zone"), var.tags, local.default_tags)}"
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  count  = "${var.enable}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(map("Name", "${var.vpc_name}-igw"), var.tags, local.default_tags)}"
}

locals {
  nat_gateway_desired_count  = "${lookup(var.nat_gateway, "behavior") == "one_nat_per_availability_zone" ? "${length(var.availability_zones)}" : 1}"
  external_elastic_ips_count = "${length(var.external_elastic_ips)}"

  create_elastic_ips = "${local.external_elastic_ips_count > 0 ? 0 : 1}"
}

locals {
  nat_gateway_count = "${length(var.external_elastic_ips) > 0 ? min(length(var.external_elastic_ips), local.nat_gateway_desired_count) : local.nat_gateway_desired_count}"
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  count = "${var.enable * local.nat_gateway_count * local.create_elastic_ips}"
  vpc   = true

  tags = "${merge(map("Name", "${var.vpc_name}-nat-gateway-${count.index}"), var.tags, local.default_tags)}"
}

# NAT gateway
resource "aws_nat_gateway" "nat" {
  count         = "${var.enable * local.nat_gateway_count}"
  allocation_id = "${element(concat("${aws_eip.nat.*.id}", "${var.external_elastic_ips}"), count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"

  depends_on = ["aws_internet_gateway.igw", "aws_eip.nat"]

  tags = "${merge(map("Name", "${var.vpc_name}-nat-gateway-${element(var.availability_zones, count.index)}"), var.tags, local.default_tags)}"
}

resource "aws_route_table" "private" {
  count  = "${var.enable * local.nat_gateway_count}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(map("Name", "${var.vpc_name}-private-rt-${count.index}", "depends_id", "${var.depends_id}"), var.tags, local.default_tags)}"
}

resource "aws_route" "private" {
  count                  = "${var.enable * local.nat_gateway_count}"
  route_table_id         = "${element(aws_route_table.private.*.id, "${count.index}")}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, "${count.index}")}"
}

# Public routing table
resource "aws_route_table" "public" {
  count  = "${var.enable}"
  vpc_id = "${aws_vpc.vpc.id}"

  tags = "${merge(map("Name", "${var.vpc_name}-public-rt", "depends_id", "${var.depends_id}"), var.tags, local.default_tags)}"
}

resource "aws_route" "public-igw" {
  count                  = "${var.enable}"
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

# Subnets
resource "aws_subnet" "public" {
  count                   = "${var.enable * "${lookup(var.public_subnets, "number_of_subnets")}"}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr, "${lookup(var.public_subnets, "newbits")}", "${lookup(var.public_subnets, "netnum_offset")}" + count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = "${merge(map("Name", "${var.vpc_name}-public-subnet-${element(var.availability_zones, count.index)}", "availability_zone", "${element(var.availability_zones, count.index)}"), var.tags, local.default_tags)}"
}

resource "aws_subnet" "private" {
  count                   = "${var.enable * "${lookup(var.private_subnets, "number_of_subnets")}"}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet(var.cidr, "${lookup(var.private_subnets, "newbits")}", "${lookup(var.private_subnets, "netnum_offset")}" + count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false

  tags = "${merge(map("Name", "${var.vpc_name}-private-subnet-${element(var.availability_zones, count.index)}", "availability_zone", "${element(var.availability_zones, count.index)}"), var.tags, local.default_tags)}"
}

resource "aws_route_table_association" "public" {
  count          = "${var.enable * "${lookup(var.public_subnets, "number_of_subnets")}"}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
  count          = "${var.enable * "${lookup(var.private_subnets, "number_of_subnets")}"}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_default_security_group" "vpc-default-sg" {
  count  = "${var.enable}"
  vpc_id = "${aws_vpc.vpc.id}"

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

  tags = "${merge(map("Name", "${var.vpc_name}-default-sg"), var.tags, local.default_tags)}"
}

resource "null_resource" "dummy_dependency" {
  depends_on = ["aws_vpc.vpc", "aws_route_table.public", "aws_default_route_table.private"]
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

  tags = "${merge(map("Name", "${var.vpc_name}-acl"), var.tags, local.default_tags)}"
}

# By default nothing is exposed to the Internet
resource "aws_default_route_table" "private" {
  count                  = "${var.enable}"
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags = "${merge(map("Name", "${var.vpc_name}-default-private-rt", "depends_id", "${var.depends_id}"), var.tags, local.default_tags)}"
}
