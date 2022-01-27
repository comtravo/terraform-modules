data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

module "vpc_enabled" {
  source = "../../../"

  enable             = true
  vpc_name           = "vpc_enabled"
  subdomain          = "foo.bar.baz"
  cidr               = "10.10.0.0/16"
  azs                = data.aws_availability_zones.available.names
  nat_az_number      = 1
  environment        = "vpc_enabled"
  replication_factor = 3
}

module "vpc_disabled" {
  source = "../../../"

  enable             = false
  vpc_name           = "vpc_disabled"
  subdomain          = "lor.em.ip.sum"
  cidr               = "10.20.0.0/16"
  azs                = data.aws_availability_zones.available.names
  nat_az_number      = 1
  environment        = "vpc_disabled"
  replication_factor = 3
}
