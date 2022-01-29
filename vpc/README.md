# Terraform AWS module for creating VPC resources

## Introduction

This module is used to create VPCs in your AWS account. It is a complete rewrite of our internal Terraform AWS VPC module. see branch (1.x).

\_Note on Terraforming elastic IPs outside of the module. The elastic IPs should be Terraformed before specifying the vpc module. So Terraform should be applied in two phases. one for EIPs and then the VPC module.\_

## Usage
Checkout [example.tf](./examples/example.tf) and [test cases](./test) for how to use this module

## Authors

Module managed by [Comtravo](https://github.com/comtravo).

## License

MIT Licensed. See [LICENSE](LICENSE) for full details.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_default_network_acl.acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) | resource |
| [aws_default_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_default_security_group.vpc-default-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public-igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_zone.net0ps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.subdomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [null_resource.dummy_dependency](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Create ipv6 CIDR block | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | List of avaliability zones | `list(string)` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR of the VPC | `string` | n/a | yes |
| <a name="input_depends_id"></a> [depends\_id](#input\_depends\_id) | Inter module dependency id | `string` | `""` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable or disable creation of resources | `bool` | `true` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostmanes in VPC | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support in VPC | `bool` | `true` | no |
| <a name="input_external_elastic_ips"></a> [external\_elastic\_ips](#input\_external\_elastic\_ips) | List of elastic IPs to use instead of creating within the module | `list(string)` | `[]` | no |
| <a name="input_nat_gateway"></a> [nat\_gateway](#input\_nat\_gateway) | NAT gateway creation behavior. If `one_nat_per_availability_zone` A NAT gateway is created per availability zone. | <pre>object({<br>    behavior = string<br>  })</pre> | <pre>{<br>  "behavior": "one_nat_per_vpc"<br>}</pre> | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Private subnet CIDR ipv4 config | <pre>object({<br>    number_of_subnets = number<br>    newbits           = number<br>    netnum_offset     = number<br>    tags              = map(string)<br>  })</pre> | <pre>{<br>  "netnum_offset": 0,<br>  "newbits": 8,<br>  "number_of_subnets": 3,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Public subnet CIDR ipv4 config | <pre>object({<br>    number_of_subnets = number<br>    newbits           = number<br>    netnum_offset     = number<br>    tags              = map(string)<br>  })</pre> | <pre>{<br>  "netnum_offset": 100,<br>  "newbits": 8,<br>  "number_of_subnets": 3,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Public subdomain name | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to tag all resources | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Name of the VPC | `string` | n/a | yes |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Map of tags to vpc | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_depends_id"></a> [depends\_id](#output\_depends\_id) | Dependency id |
| <a name="output_elastic_ips"></a> [elastic\_ips](#output\_elastic\_ips) | List of elastic ips |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | NAT gateway ids |
| <a name="output_net0ps_zone_id"></a> [net0ps\_zone\_id](#output\_net0ps\_zone\_id) | Private hosted zone id |
| <a name="output_private_subdomain"></a> [private\_subdomain](#output\_private\_subdomain) | Private hosted zone name |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of private subnets |
| <a name="output_private_zone_id"></a> [private\_zone\_id](#output\_private\_zone\_id) | Private hosted zone name |
| <a name="output_public_subdomain"></a> [public\_subdomain](#output\_public\_subdomain) | Public hosted zone name |
| <a name="output_public_subdomain_zone_id"></a> [public\_subdomain\_zone\_id](#output\_public\_subdomain\_zone\_id) | Public hosted zone id |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of public subnets |
| <a name="output_subdomain_zone_id"></a> [subdomain\_zone\_id](#output\_subdomain\_zone\_id) | Public hosted zone id |
| <a name="output_vpc_default_sg"></a> [vpc\_default\_sg](#output\_vpc\_default\_sg) | Default security group |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC id |
| <a name="output_vpc_private_routing_table_ids"></a> [vpc\_private\_routing\_table\_ids](#output\_vpc\_private\_routing\_table\_ids) | Private routing table id |
| <a name="output_vpc_public_routing_table_id"></a> [vpc\_public\_routing\_table\_id](#output\_vpc\_public\_routing\_table\_id) | Public routing table id |
