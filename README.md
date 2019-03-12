# terraform-aws-vpc

## Introduction:
This module is used to create VPCs in your AWS account. It is a complete rewrite of our internal Terraform AWS VPC module. see branch (1.x).

## Current features
* **Conditionally enable / disable VPC creation.** It is helpful when for example you want to conditionally create multiple VPCs in a single environment for reasons such as VPC peering.
* This module helps **create explicit dependencies between VPCs and VPC peering** so that there is no race condition between VPC creation and VPC peering.
* **Create a private Route 53 hosted zone**.
* **Conditionally create a Route 53 public hosted zone**. For example, if your master account has `foo.com` and you want bar.foo.com to be terraformed in your sub account, you could specify `subdomain = "bar.foo.com"` and setup `DNS` propogation in your master account for `bar.foo.com`
* Configure optionally, your private and public subnet configuration by specifying the number of subnets to be created, newbits and netnum_offset. Subnetting should be handled externally to this module. See [CIDR subnetting in terraform](https://www.terraform.io/docs/configuration-0-11/interpolation.html#cidrsubnet-iprange-newbits-netnum-)
* You can **provide external elastic ips** to the terraform module and those would be used to create the NAT gateways. (useful for retaining ***"whilelisted"*** IP addresses in case you would have to teardown the VPC for some reason)

*Note on Terraforming elastic IPs outside of the module. The elastic IPs should be Terraformed before specifying the vpc module. So Terraform should be applied in two phases. one for EIPs and then the VPC module.*


Refer to [variable.tf](./variables.tf) for more configurable options and [outputs.tf](./outputs.tf) for exposed outputs


## Usage:
```hcl
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_eip" "nat" {
  count = 3
  vpc   = true

  tags {
    Name = "${terraform.workspace}-nat-gateway-eip-${count.index}"
    environment = "${terraform.workspace}"
  }
}

module "infra_vpc" {
  source = "github.com/comtravo/terraform-aws-vpc?ref=2.1.0"

  enable             = 1
  vpc_name           = "${terraform.workspace}"
  cidr               = "${var.ct_vpc_cidr}"
  availability_zones = "${data.aws_availability_zones.available.names}"
  subdomain          = "${terraform.workspace}.comtravo.com"
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

  # This **optional** config uses the provided elastic IPs instead of creating new ones
  #
  #
  external_elastic_ips = ["${aws_eip.nat.*.id}"]
  # Note:
  # When both elastic IPs are given and nat_gateway behavior = one_nat_per_availability_zone,
  # The number of NAT gateways created is min(length(elastic_ips), length(availability_zones))
  
  

  # This **optional** block creates NAT gateways in all the availability zones and
  # creates associated route tables and assigns it to the private subnets.
  #
  nat_gateway {
    behavior = "one_nat_per_availability_zone"
  }
  # Note:
  # Default behavior: 

  tags {
    environment = "${terraform.workspace}"
  }
}
```
