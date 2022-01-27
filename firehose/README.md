# Terraform AWS module for AWS Kinesis Firehose

## Introduction

This module creates a Kinesis Firehose and all the resources related to it to log to S3.

## Usage  
Checkout [test.tf](./tests/test.tf) for how to use this module

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| account\_id | AWS account ID | `string` | n/a | yes |
| destination | Kinesis Firehose Destination | `string` | `"s3"` | no |
| enable | Enable firehose | `bool` | `true` | no |
| name | Name of the firehose | `string` | n/a | yes |
| region | AWS region | `string` | `"eu-west-1"` | no |
| s3\_configuration | AWS S3 configuration | <pre>object({<br>    bucket_arn      = string,<br>    buffer_interval = number,<br>    buffer_size     = number,<br>    prefix          = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the Kinesis Firehose |
