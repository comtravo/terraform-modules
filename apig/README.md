# Terraform AWS module for API gateway with Swagger spec

## Introduction
This is a minimal Terraform module which accepts a AWS + Swagger spec and deploys an AWS API Gateway

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
| [aws_api_gateway_base_path_mapping.custom-domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_base_path_mapping) | resource |
| [aws_api_gateway_deployment.api-deployment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment) | resource |
| [aws_api_gateway_rest_api.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_rest_api) | resource |
| [aws_api_gateway_stage.stage](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_stage) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_definition"></a> [definition](#input\_definition) | Definition of the API Gateway | `string` | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Custom domain name | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the API gateway deployment | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Name of the stage to which deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_execution_arn"></a> [deployment\_execution\_arn](#output\_deployment\_execution\_arn) | Deployment execution ARN |
| <a name="output_deployment_id"></a> [deployment\_id](#output\_deployment\_id) | Deployment id |
| <a name="output_deployment_invoke_url"></a> [deployment\_invoke\_url](#output\_deployment\_invoke\_url) | Deployment invoke url |
| <a name="output_name"></a> [name](#output\_name) | API Gateway name |
| <a name="output_rest_api_id"></a> [rest\_api\_id](#output\_rest\_api\_id) | REST API id |
| <a name="output_url"></a> [url](#output\_url) | Serverless invoke url |
