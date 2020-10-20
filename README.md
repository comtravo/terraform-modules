# Terraform AWS module for creating VPC resources

## Introduction

This module is used to create VPCs in your AWS account. It is a complete rewrite of our internal Terraform AWS VPC module. see branch (1.x).

_Note on Terraforming elastic IPs outside of the module. The elastic IPs should be Terraformed before specifying the vpc module. So Terraform should be applied in two phases. one for EIPs and then the VPC module._

## Usage  
Checkout [example.tf](./examples/example.tf) and [test cases](./test) for how to use this module

## Authors

Module managed by [Comtravo](https://github.com/comtravo).

## License

MIT Licensed. See [LICENSE](LICENSE) for full details.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.0 |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| assign_generated_ipv6_cidr_block | Create ipv6 CIDR block | `bool` | `true` | no |
| availability_zones | List of avaliability zones | `list(string)` | n/a | yes |
| cidr | CIDR of the VPC | `string` | n/a | yes |
| depends_id | Inter module dependency id | `string` | `""` | no |
| enable | Enable or disable creation of resources | `bool` | `true` | no |
| enable_dns_hostnames | Enable DNS hostmanes in VPC | `bool` | `true` | no |
| enable_dns_support | Enable DNS support in VPC | `bool` | `true` | no |
| external_elastic_ips | List of elastic IPs to use instead of creating within the module | `list(string)` | `[]` | no |
| nat_gateway | NAT gateway creation behavior. If `one_nat_per_availability_zone` A NAT gateway is created per availability zone. | <pre>object({<br>    behavior = string<br>  })</pre> | <pre>{<br>  "behavior": "one_nat_per_vpc"<br>}</pre> | no |
| private_subnets | Private subnet CIDR ipv4 config | <pre>object({<br>    number_of_subnets = number<br>    newbits           = number<br>    netnum_offset     = number<br>    tags              = map(string)<br>  })</pre> | <pre>{<br>  "netnum_offset": 0,<br>  "newbits": 8,<br>  "number_of_subnets": 3,<br>  "tags": {}<br>}</pre> | no |
| public_subnets | Public subnet CIDR ipv4 config | <pre>object({<br>    number_of_subnets = number<br>    newbits           = number<br>    netnum_offset     = number<br>    tags              = map(string)<br>  })</pre> | <pre>{<br>  "netnum_offset": 100,<br>  "newbits": 8,<br>  "number_of_subnets": 3,<br>  "tags": {}<br>}</pre> | no |
| subdomain | Public subdomain name | `string` | `""` | no |
| tags | Map of tags to tag all resources | `map(string)` | `{}` | no |
| vpc_name | Name of the VPC | `string` | n/a | yes |
| vpc_tags | Map of tags to vpc | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| depends_id | Dependency id |
| elastic_ips | List of elastic ips |
| nat_gateway_ids | NAT gateway ids |
| net0ps_zone_id | Private hosted zone id |
| private_subdomain | Private hosted zone name |
| private_subnets | List of private subnets |
| private_zone_id | Private hosted zone name |
| public_subdomain | Public hosted zone name |
| public_subdomain_zone_id | Public hosted zone id |
| public_subnets | List of public subnets |
| subdomain_zone_id | Public hosted zone id |
| vpc_default_sg | Default security group |
| vpc_id | VPC id |
| vpc_private_routing_table_ids | Private routing table id |
| vpc_public_routing_table_id | Public routing table id |

