## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_kinesis_stream.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_configuration"></a> [configuration](#input\_configuration) | Kinesis stream configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream | <pre>object({<br>    name                      = string<br>    shard_count               = number<br>    retention_period          = number<br>    shard_level_metrics       = list(string)<br>    enforce_consumer_deletion = bool<br>    encryption_type           = string<br>    kms_key_id                = string<br>    tags                      = map(string)<br>  })</pre> | n/a | yes |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable module | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | AWS Kinesis attributes |
