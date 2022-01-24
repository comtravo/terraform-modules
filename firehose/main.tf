/**
* # Terraform AWS module for AWS Kinesis Firehose
*
* ## Introduction
*
* This module creates a Kinesis Firehose and all the resources related to it to log to S3.
*
* ## Usage
* Checkout [test.tf](./tests/test.tf) for how to use this module
*
* ## Authors
*
* Module managed by [Comtravo](https://github.com/comtravo).
*
* ## License
*
* MIT Licensed. See [LICENSE](LICENSE) for full details.
*/

###############################################################################
#                                    VARIABLES                                #
###############################################################################

variable "name" {
  type        = string
  description = "Name of the firehose"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

variable "region" {
  default     = "eu-west-1"
  type        = string
  description = "AWS region"
}

variable "destination" {
  default     = "s3"
  type        = string
  description = "Kinesis Firehose Destination"
}

variable "s3_configuration" {
  type = object({
    bucket_arn      = string,
    buffer_interval = number,
    buffer_size     = number,
    prefix          = string
  })
  description = "AWS S3 configuration"
}

variable "enable" {
  type        = bool
  description = "Enable firehose"
  default     = true
}

locals {
  enable_count = var.enable ? 1 : 0
}

###############################################################################
#                                    MAIN                                     #
###############################################################################

resource "aws_iam_role" "firehose_role" {
  count                 = local.enable_count
  name                  = var.name
  path                  = "/environment/${terraform.workspace}/"
  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

data "aws_iam_policy_document" "firehose_role" {
  statement {
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      lookup(var.s3_configuration, "bucket_arn"),
      "${lookup(var.s3_configuration, "bucket_arn")}/*"
    ]
  }

  statement {
    actions = [
      "logs:*",
    ]

    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:/aws/kinesisfirehose/${var.name}:log-stream:*",
    ]
  }
}

resource "aws_iam_role_policy" "firehose_role" {
  count = local.enable_count
  name  = var.name
  role  = aws_iam_role.firehose_role[0].id

  policy = data.aws_iam_policy_document.firehose_role.json
}

resource "aws_kinesis_firehose_delivery_stream" "stream" {
  count       = local.enable_count
  name        = var.name
  destination = var.destination

  s3_configuration {
    role_arn        = aws_iam_role.firehose_role[0].arn
    bucket_arn      = lookup(var.s3_configuration, "bucket_arn")
    buffer_interval = lookup(var.s3_configuration, "buffer_interval")
    buffer_size     = lookup(var.s3_configuration, "buffer_size")
    prefix          = lookup(var.s3_configuration, "prefix")

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${var.name}"
      log_stream_name = "S3Delivery"
    }
  }
}

output "arn" {
  value       = var.enable ? aws_kinesis_firehose_delivery_stream.stream[0].arn : ""
  description = "ARN of the Kinesis Firehose"
}
