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
| terraform | >= 0.12 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| null | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azs | Availability zones | `list(string)` | n/a | yes |
| cidr | CIDR | `string` | n/a | yes |
| depends_id | For inter module dependencies | `string` | `""` | no |
| enable | Enable or Disable the module | `bool` | n/a | yes |
| enable_dns_hostnames | Enable DNS hostnames | `bool` | `true` | no |
| enable_dns_support | Enable DNS support | `bool` | `true` | no |
| environment | Environment | `string` | n/a | yes |
| nat_az_number | Subnet number to deploy NAT gateway in | `number` | `0` | no |
| private_subnet_tags | n/a | `map(string)` | `{}` | no |
| public_subnet_tags | n/a | `map(string)` | `{}` | no |
| replication_factor | Number of subnets, routing tables, NAT gateways | `number` | n/a | yes |
| subdomain | Subdomain name | `string` | `""` | no |
| tags | n/a | `map(string)` | `{}` | no |
| vpc_name | VPC name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| depends_id | Dependency ID |
| net0ps_zone_id | Private hosted zone ID |
| private_subdomain | Private subdomain name |
| private_subnets | Private subnets |
| private_zone_id | Private hosted zone ID |
| public_subdomain | Public subdomain name |
| public_subdomain_name_servers | Public subdomain name servers |
| public_subdomain_zone_id | Subdomain hosted zone ID |
| public_subnets | Public subnets |
| subdomain_zone_id | Subdomain hosted zone ID |
| vpc_default_sg | Default VPC security group |
| vpc_id | VPC ID |
| vpc_private_routing_table_id | Private routing table ID |
| vpc_public_routing_table_id | Public routing table ID |

