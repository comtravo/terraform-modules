# Terraform AWS module for AWS Kinesis Firehose

## Introduction

This module create a Kinesis Firehose and all the resources related to it to log to S3.

## Usage

```hcl
module "my_firehose" {
  source = "github.com/comtravo/terraform-aws-firehose"

  enable = 1

  name        = "test-firehose"
  destination = "s3"

  s3_configuration {
    bucket_arn      = "my_s3_bucket_arn"
    buffer_interval = 60
    prefix          = "some-prefix/"
  }

  account_id = "0123456789012"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| account\_id | AWS account ID | string | n/a | yes |
| name | Name of the firehose | string | n/a | yes |
| destination | Kinesis Firehose Destination | string | `"s3"` | no |
| enable | Enable firehose | string | `"1"` | no |
| region | AWS region | string | `"eu-west-1"` | no |
| s3\_configuration | AWS S3 configuration | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of the Kinesis Firehose |

## Authors

Module managed by [Comtravo](https://github.com/comtravo).

## License

MIT Licensed. See LICENSE for full details.
