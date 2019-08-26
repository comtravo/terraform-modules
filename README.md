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

## Authors

Module managed by [Comtravo](https://github.com/comtravo).

## License

MIT Licensed. See LICENSE for full details.
