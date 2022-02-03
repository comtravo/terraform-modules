# Terraform AWS module for [AWS API gateway V2](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html) with OpenAPI spec

## Introduction
This is a minimal Terraform module which accepts a AWS + OpenAPI spec and deploys an [AWS API Gateway V2](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html)

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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_api_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_deployment) | resource |
| [aws_apigatewayv2_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_apigatewayv2_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_log_settings"></a> [access\_log\_settings](#input\_access\_log\_settings) | https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html#apigateway-cloudwatch-log-formats | <pre>object({<br>    format            = string<br>    retention_in_days = number<br>  })</pre> | <pre>{<br>  "format": "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\", \"status\":\"$context.status\",\"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\" }",<br>  "retention_in_days": 90<br>}</pre> | no |
| <a name="input_body"></a> [body](#input\_body) | Definition of the API Gateway | `string` | n/a | yes |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#cors_configuration | <pre>list(object({<br>    allow_credentials = bool<br>    allow_headers     = list(string)<br>    allow_methods     = list(string)<br>    allow_origins     = list(string)<br>    expose_headers    = list(string)<br>    max_age           = number<br>  }))</pre> | `[]` | no |
| <a name="input_domain_settings"></a> [domain\_settings](#input\_domain\_settings) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name | <pre>object({<br>    enable          = bool<br>    domain_name     = string<br>    zone_id         = string<br>    certificate_arn = string<br>    endpoint_type   = string<br>    security_policy = string<br>  })</pre> | <pre>{<br>  "certificate_arn": "",<br>  "domain_name": "",<br>  "enable": false,<br>  "endpoint_type": "",<br>  "security_policy": "",<br>  "zone_id": ""<br>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the API gateway deployment | `string` | n/a | yes |
| <a name="input_protocol_type"></a> [protocol\_type](#input\_protocol\_type) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#protocol_type | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Name of the stage to which deployed | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags for resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_apigatewayv2_api"></a> [aws\_apigatewayv2\_api](#output\_aws\_apigatewayv2\_api) | aws\_apigatewayv2\_api outputs |
| <a name="output_aws_apigatewayv2_api_mapping"></a> [aws\_apigatewayv2\_api\_mapping](#output\_aws\_apigatewayv2\_api\_mapping) | aws\_apigatewayv2\_api\_mapping outputs |
| <a name="output_aws_apigatewayv2_deployment"></a> [aws\_apigatewayv2\_deployment](#output\_aws\_apigatewayv2\_deployment) | aws\_apigatewayv2\_deployment outputs |
| <a name="output_aws_apigatewayv2_domain_name"></a> [aws\_apigatewayv2\_domain\_name](#output\_aws\_apigatewayv2\_domain\_name) | aws\_apigatewayv2\_domain\_name outputs |
| <a name="output_aws_apigatewayv2_stage"></a> [aws\_apigatewayv2\_stage](#output\_aws\_apigatewayv2\_stage) | aws\_apigatewayv2\_stage outputs |
| <a name="output_aws_cloudwatch_log_group"></a> [aws\_cloudwatch\_log\_group](#output\_aws\_cloudwatch\_log\_group) | aws\_cloudwatch\_log\_group outputs |
| <a name="output_aws_route53_record"></a> [aws\_route53\_record](#output\_aws\_route53\_record) | aws\_route53\_record outputs |
