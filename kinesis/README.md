## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable | Enable module | `bool` | `true` | no |
| encryption\_type | AWS Kinesis stream encryption type | `string` | `"KMS"` | no |
| enforce\_consumer\_deletion | AWS Kinesis stream enforce deleting consumers before deleting the stream | `bool` | `true` | no |
| kms\_key\_id | AWS Kinesis stream KMS key ID | `string` | `"alias/aws/kinesis"` | no |
| name | Name of the AWS Kinesis stream | `string` | n/a | yes |
| retention\_period | AWS Kinesis stream retention period | `number` | `24` | no |
| shard\_count | AWS Kinesis stream shard count | `number` | `1` | no |
| shard\_level\_metrics | AWS Kinesis stream shard level metrics | `list(string)` | `[]` | no |
| tags | AWS Kinesis stream tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| output | AWS Kinesis attributes |
