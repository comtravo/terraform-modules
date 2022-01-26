## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | SQS Name | `string` | n/a | yes |
| sns\_subscriptions\_arns | SNS Topic ARNs to subscribe to | `list(string)` | `[]` | no |
| visibility\_timeout\_seconds | SQS Visibility Timeout in Seconds | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| queue | SQS attributes |
| queue-dlq | SQS DLQ attributes |
