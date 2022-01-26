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
| terraform | >= 0.13 |
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
| depends\_id | For inter module dependencies | `string` | `""` | no |
| enable | Enable or Disable the module | `bool` | n/a | yes |
| enable\_dns\_hostnames | Enable DNS hostnames | `bool` | `true` | no |
| enable\_dns\_support | Enable DNS support | `bool` | `true` | no |
| environment | Environment | `string` | n/a | yes |
| nat\_az\_number | Subnet number to deploy NAT gateway in | `number` | `0` | no |
| private\_subnet\_tags | n/a | `map(string)` | `{}` | no |
| public\_subnet\_tags | n/a | `map(string)` | `{}` | no |
| replication\_factor | Number of subnets, routing tables, NAT gateways | `number` | n/a | yes |
| subdomain | Subdomain name | `string` | `""` | no |
| tags | n/a | `map(string)` | `{}` | no |
| vpc\_name | VPC name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| depends\_id | Dependency ID |
| net0ps\_zone\_id | Private hosted zone ID |
| private\_subdomain | Private subdomain name |
| private\_subnets | Private subnets |
| private\_zone\_id | Private hosted zone ID |
| public\_subdomain | Public subdomain name |
| public\_subdomain\_name\_servers | Public subdomain name servers |
| public\_subdomain\_zone\_id | Subdomain hosted zone ID |
| public\_subnets | Public subnets |
| subdomain\_zone\_id | Subdomain hosted zone ID |
| vpc\_default\_sg | Default VPC security group |
| vpc\_id | VPC ID |
| vpc\_private\_routing\_table\_id | Private routing table ID |
| vpc\_public\_routing\_table\_id | Public routing table ID |
