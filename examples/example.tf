data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}

module "vpc_enabled" {
  source = "../../../"

  enable             = true
  vpc_name           = "vpc_enabled"
  cidr               = "10.10.0.0/16"
  availability_zones = data.aws_availability_zones.available.names
  depends_id         = ""

  tags {
    environment = "vpc_enabled"
  }
}

module "vpc_disabled" {
  source = "../../../"

  enable             = false
  vpc_name           = "vpc_disabled"
  cidr               = "10.10.0.0/16"
  availability_zones = data.aws_availability_zones.available.names
  depends_id         = ""

  tags {
    environment = "vpc_disabled"
  }
}
