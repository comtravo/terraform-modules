# Terraform AWS module for creating VPC resources

## Introduction

This module creates a AWS VPC and all the resources related to it.  
This module is used to create VPCs in your AWS account. It is a complete rewrite of our internal Terraform AWS VPC module. see branch (1.x).

\*\*Note on Terraforming elastic IPs outside of the module. The elastic IPs should be Terraformed before specifying the vpc module. So Terraform should be applied in two phases. one for EIPs and then the VPC module.\*\*

## Usage  
Checkout [example.tf](./examples/example.tf) for how to use this module

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
| availability\_zones | List of avaliability zones | `list(string)` | n/a | yes |
| cidr | CIDR of the VPC | `string` | n/a | yes |
| vpc\_name | Name of the VPC | `string` | n/a | yes |
| assign\_generated\_ipv6\_cidr\_block | Create ipv6 CIDR block | `bool` | `true` | no |
| depends\_id | Inter module dependency id | `string` | `""` | no |
| enable | Enable or disable creation of resources | `bool` | `true` | no |
| enable\_dns\_hostnames | Enable DNS hostmanes in VPC | `bool` | `true` | no |
| enable\_dns\_support | Enable DNS support in VPC | `bool` | `true` | no |
| external\_elastic\_ips | List of elastic IPs to use instead of creating within the module | `list(string)` | `[]` | no |
| nat\_gateway | NAT gateway creation behavior. If `one_nat_per_availability_zone` A NAT gateway is created per availability zone. | <pre>object({<br>    behavior = string<br>  })</pre> | <pre>{<br>  "behavior": "one_nat_per_vpc"<br>}</pre> | no |
| private\_subnets | Private subnet CIDR ipv4 config | <pre>object({<br>    number_of_subnets = number<br>    newbits           = number<br>    netnum_offset     = number<br>  })</pre> | <pre>{<br>  "netnum_offset": 0,<br>  "newbits": 8,<br>  "number_of_subnets": 3<br>}</pre> | no |
| public\_subnets | Public subnet CIDR ipv4 config | <pre>object({<br>    number_of_subnets = number<br>    newbits           = number<br>    netnum_offset     = number<br>  })</pre> | <pre>{<br>  "netnum_offset": 100,<br>  "newbits": 8,<br>  "number_of_subnets": 3<br>}</pre> | no |
| subdomain | Public subdomain name | `string` | `""` | no |
| tags | Map of tags to tag resources | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| depends\_id | Dependency id |
| elastic\_ips | List of elastic ips |
| nat\_gateway\_ids | NAT gateway ids |
| net0ps\_zone\_id | Private hosted zone id |
| private\_subdomain | Private hosted zone name |
| private\_subnets | List of private subnets |
| private\_zone\_id | Private hosted zone name |
| public\_subdomain | Public hosted zone name |
| public\_subdomain\_zone\_id | Public hosted zone id |
| public\_subnets | List of public subnets |
| subdomain\_zone\_id | Public hosted zone id |
| vpc\_default\_sg | Default security group |
| vpc\_id | VPC id |
| vpc\_private\_routing\_table\_id | Private routing table id |
| vpc\_public\_routing\_table\_id | Public routing table id |

