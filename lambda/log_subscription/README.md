## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.lambda_cloudwatch_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_subscription"></a> [cloudwatch\_log\_subscription](#input\_cloudwatch\_log\_subscription) | Lambda CloudWatch log subscription | <pre>object({<br>    filter_pattern : string<br>    destination_arn : string<br>  })</pre> | n/a | yes |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable this module | `bool` | `false` | no |
| <a name="input_lambda_name"></a> [lambda\_name](#input\_lambda\_name) | Lambda name | `string` | n/a | yes |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | Lambda log group name | `string` | n/a | yes |

## Outputs

No outputs.
