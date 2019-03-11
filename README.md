# terraform-aws-vpc

## Introduction:
This module is used to create VPCs in your AWS account. It is a complete rewrite of our internal Terraform AWS VPC module. see branch (1.x).

## Current features
* Conditionally enable / disable VPC creation. It is helpful when for example you want to conditionally create multiple VPCs in a single environment for reasons such as VPC peering.
* This module helps create explicit dependencies between VPCs and VPC peering so that there is no race condition between VPC creation and VPC peering.
* Creates a private Route 53 hosted zone.
* Conditionally creates a Route 53 public hosted zone. For example, if your master account has foo.com and you want bar.foo.com to be terraformed in your sub account, you could specify `subdomain = "bar.foo.com"` and setup DNS propogation in your master account for `bar.foo.com`
* Configure optionally, your private and public subnet configurationby specifying the number of subnets to be created, newbits and netnum_offset. Subnetting should be handled externally to this module. See [CIDR subnetting in terraform](https://www.terraform.io/docs/configuration-0-11/interpolation.html#cidrsubnet-iprange-newbits-netnum-)

* See [variable.tf](./variables.tf) for more configurable options.
* See [outputs.tf](./outputs.tf) for more 



## Usage:
```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

module "infra_vpc" {
  source = "github.com/comtravo/terraform-aws-vpc?ref=2.x"

  enable             = 1
  vpc_name           = "${terraform.workspace}"
  cidr               = "${var.ct_vpc_cidr}"
  availability_zones = "${data.aws_availability_zones.available.names}"
  subdomain          = "${terraform.workspace}.foo.com"
  depends_id         = ""

  private_subnets {
    number_of_subnets = 3
    newbits           = 4
    netnum_offset     = 0
  }

  public_subnets {
    number_of_subnets = 3
    newbits           = 4
    netnum_offset     = 8
  }

  tags {
    environment = "${terraform.workspace}"
  }
}

```