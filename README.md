# Terraform AWS module for [AWS API gateway V2](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html) with OpenAPI spec

## Introduction  
This is a minimal Terraform module which accepts a AWS + OpenAPI spec and deploys an [AWS API Gateway V2](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)

## Usage  
Check [examples](./examples) on how to use this module

## Authors

Module managed by [Comtravo](https://github.com/comtravo).

License
-------

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_log\_settings | https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html#apigateway-cloudwatch-log-formats | <pre>object({<br>    enable = bool<br>    format = string<br>  })</pre> | <pre>{<br>  "enable": true,<br>  "format": "JSON"<br>}</pre> | no |
| body | Definition of the API Gateway | `string` | n/a | yes |
| cors\_configuration | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#cors_configuration | `map` | `{}` | no |
| domain\_name | Custom domain name | `string` | `""` | no |
| domain\_settings | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name | <pre>object({<br>    enable          = bool<br>    domain_name     = string<br>    zone_id         = string<br>    certificate_arn = string<br>    endpoint_type   = string<br>    security_policy = string<br>  })</pre> | <pre>{<br>  "certificate_arn": "",<br>  "domain_name": "",<br>  "enable": false,<br>  "endpoint_type": "",<br>  "security_policy": "",<br>  "zone_id": ""<br>}</pre> | no |
| name | Name of the API gateway deployment | `string` | n/a | yes |
| protocol\_type | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#protocol_type | `string` | n/a | yes |
| stage | Name of the stage to which deployed | `string` | n/a | yes |
| tags | Tags for resources | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_apigatewayv2\_api | aws\_apigatewayv2\_api outputs |
| aws\_apigatewayv2\_deployment | aws\_apigatewayv2\_deployment outputs |
| aws\_apigatewayv2\_domain\_name | aws\_apigatewayv2\_domain\_name outputs |
| aws\_apigatewayv2\_stage | aws\_apigatewayv2\_stage outputs |
| aws\_route53\_record | aws\_route53\_record outputs |
