data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  private_subnets = {
    number_of_subnets = 4
    newbits           = 4
    netnum_offset     = 0
  }

  public_subnets = {
    number_of_subnets = 1
    newbits           = 4
    netnum_offset     = 8
  }
}

module "datascience_vpc" {
  source = "../"

  enable             = true
  vpc_name           = terraform.workspace
  cidr               = "10.30.0.0/16"
  availability_zones = "${data.aws_availability_zones.available.names}"

  private_subnets = local.private_subnets

  public_subnets = local.public_subnets

  tags {
    environment = terraform.workspace
  }
}
