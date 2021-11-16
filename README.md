# Terraform AWS module for AWS Lambda

## Introduction  
This module creates an AWS lambda and all the related resources. It is a complete re-write of our internal terraform lambda module.

## Usage  
Checkout [examples](./examples) on how to use this module for various trigger sources.
## Authors

Module managed by [Comtravo](https://github.com/comtravo).

## License

MIT Licensed. See LICENSE for full details.

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
| cloudwatch\_log\_retention | Enable Cloudwatch logs retention | `number` | `90` | no |
| cloudwatch\_log\_subscription | Cloudwatch log stream configuration | <pre>object({<br>    enable : bool<br>    filter_pattern : string<br>    destination_arn : string<br>  })</pre> | <pre>{<br>  "destination_arn": "",<br>  "enable": false,<br>  "filter_pattern": ""<br>}</pre> | no |
| description | Lambda function description | `string` | `"Managed by Terraform"` | no |
| environment | Lambda environment variables | `map(string)` | `null` | no |
| file\_name | Lambda function filename name | `string` | `null` | no |
| function\_name | Lambda function name | `string` | n/a | yes |
| handler | Lambda function handler | `string` | n/a | yes |
| image\_config | Container image configuration values that override the values in the container image Dockerfile. | <pre>object({<br>    command           = list(string)<br>    entry_point       = list(string)<br>    working_directory = string<br>  })</pre> | `null` | no |
| image\_uri | ECR image URI containing the function's deployment package | `string` | `null` | no |
| kinesis\_configuration | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_event_source_mapping | <pre>map(object({<br>    batch_size                                      = number<br>    bisect_batch_on_function_error                  = bool<br>    destination_config__on_failure__destination_arn = string<br>    event_source_arn                                = string<br>    maximum_batching_window_in_seconds              = number<br>    maximum_record_age_in_seconds                   = number<br>    maximum_retry_attempts                          = number<br>    parallelization_factor                          = number<br>    starting_position                               = string<br>    starting_position_timestamp                     = string<br>    tumbling_window_in_seconds                      = number<br>  }))</pre> | `{}` | no |
| layers | List of layers for this lambda function | `list(string)` | `[]` | no |
| memory\_size | Lambda function memory size | `number` | `128` | no |
| publish | Publish lambda function | `bool` | `false` | no |
| region | AWS region | `string` | n/a | yes |
| reserved\_concurrent\_executions | Reserved concurrent executions  for this lambda function | `number` | `-1` | no |
| role | Lambda function role | `string` | n/a | yes |
| runtime | Lambda function runtime | `string` | `"nodejs14.x"` | no |
| sqs\_external | External SQS to consume | <pre>object({<br>    batch_size = number<br>    sqs_arns   = list(string)<br>  })</pre> | `null` | no |
| tags | Tags for this lambda function | `map(string)` | `{}` | no |
| timeout | Lambda function runtime | `number` | `300` | no |
| tracing\_config | https://www.terraform.io/docs/providers/aws/r/lambda_function.html | <pre>object({<br>    mode : string<br>  })</pre> | <pre>{<br>  "mode": "PassThrough"<br>}</pre> | no |
| trigger | Trigger configuration for this lambda function | `any` | n/a | yes |
| vpc\_config | Lambda VPC configuration | <pre>object({<br>    subnet_ids : list(string)<br>    security_group_ids : list(string)<br>  })</pre> | <pre>{<br>  "security_group_ids": [],<br>  "subnet_ids": []<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | AWS lambda arn |
| dlq | AWS lambda Dead Letter Queue details |
| function\_name | AWS lambda function name |
| invoke\_arn | AWS lambda invoke\_arn |
| qualified\_arn | AWS lambda qualified\_arn |
| queue | AWS lambda SQS details |
| sns\_topics | AWS lambda SNS topics if any |
| version | AWS lambda version |
