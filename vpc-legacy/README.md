# Terraform AWS module for creating VPC resources

## Introduction

This module creates a AWS VPC and all the resources related to it to log to VPC.

## Usage
Checkout [example.tf](./examples/example.tf) for how to use this module

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
| [aws_route.private-nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public-igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route53_zone.net0ps](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_route53_zone.subdomain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
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
| <a name="input_azs"></a> [azs](#input\_azs) | Availability zones | `list(string)` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | CIDR | `string` | n/a | yes |
| <a name="input_depends_id"></a> [depends\_id](#input\_depends\_id) | For inter module dependencies | `string` | `""` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable or Disable the module | `bool` | n/a | yes |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Enable DNS hostnames | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Enable DNS support | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_nat_az_number"></a> [nat\_az\_number](#input\_nat\_az\_number) | Subnet number to deploy NAT gateway in | `number` | `0` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_replication_factor"></a> [replication\_factor](#input\_replication\_factor) | Number of subnets, routing tables, NAT gateways | `number` | n/a | yes |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | Subdomain name | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_depends_id"></a> [depends\_id](#output\_depends\_id) | Dependency ID |
| <a name="output_net0ps_zone_id"></a> [net0ps\_zone\_id](#output\_net0ps\_zone\_id) | Private hosted zone ID |
| <a name="output_private_subdomain"></a> [private\_subdomain](#output\_private\_subdomain) | Private subdomain name |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | Private subnets |
| <a name="output_private_zone_id"></a> [private\_zone\_id](#output\_private\_zone\_id) | Private hosted zone ID |
| <a name="output_public_subdomain"></a> [public\_subdomain](#output\_public\_subdomain) | Public subdomain name |
| <a name="output_public_subdomain_name_servers"></a> [public\_subdomain\_name\_servers](#output\_public\_subdomain\_name\_servers) | Public subdomain name servers |
| <a name="output_public_subdomain_zone_id"></a> [public\_subdomain\_zone\_id](#output\_public\_subdomain\_zone\_id) | Subdomain hosted zone ID |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | Public subnets |
| <a name="output_subdomain_zone_id"></a> [subdomain\_zone\_id](#output\_subdomain\_zone\_id) | Subdomain hosted zone ID |
| <a name="output_vpc_default_sg"></a> [vpc\_default\_sg](#output\_vpc\_default\_sg) | Default VPC security group |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID |
| <a name="output_vpc_private_routing_table_id"></a> [vpc\_private\_routing\_table\_id](#output\_vpc\_private\_routing\_table\_id) | Private routing table ID |
| <a name="output_vpc_public_routing_table_id"></a> [vpc\_public\_routing\_table\_id](#output\_vpc\_public\_routing\_table\_id) | Public routing table ID |
