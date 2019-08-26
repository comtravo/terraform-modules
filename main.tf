###############################################################################
#                                    VARIABLES                                #
###############################################################################

variable name {
  type        = "string"
  description = "Name of the firehose"
}

variable account_id {
  type        = "string"
  description = "AWS account ID"
}

variable region {
  default     = "eu-west-1"
  type        = "string"
  description = "AWS region"
}

variable destination {
  default = "s3"
}

variable s3_configuration {
  type        = "map"
  description = "AWS S3 configuration"
  default     = {}
}

variable enable {
  type        = "string"
  description = "Enable firehose"
  default     = "1"
}

###############################################################################
#                                    MAIN                                     #
###############################################################################

resource "aws_iam_role" "firehose_role" {
  name                  = "${var.name}"
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
      "${lookup(var.s3_configuration, "bucket_arn")}",
      "${lookup(var.s3_configuration, "bucket_arn")}/*",
      "arn:aws:s3:::%FIREHOSE_BUCKET_NAME%",
      "arn:aws:s3:::%FIREHOSE_BUCKET_NAME%/*",
    ]
  }

  statement {
    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration",
    ]

    resources = [
      "arn:aws:lambda:${var.region}:${var.account_id}:function:%FIREHOSE_DEFAULT_FUNCTION%:%FIREHOSE_DEFAULT_VERSION%",
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
  name = "${var.name}"
  role = "${aws_iam_role.firehose_role.id}"

  policy = "${data.aws_iam_policy_document.firehose_role.json}"
}

resource "aws_kinesis_firehose_delivery_stream" "stream" {
  count       = "${var.enable}"
  name        = "${var.name}"
  destination = "${var.destination}"

  s3_configuration {
    role_arn        = "${aws_iam_role.firehose_role.arn}"
    bucket_arn      = "${lookup(var.s3_configuration, "bucket_arn")}"
    buffer_interval = "${lookup(var.s3_configuration, "buffer_interval", 300)}"
    buffer_size     = "${lookup(var.s3_configuration, "buffer_size", 5)}"
    prefix          = "${lookup(var.s3_configuration, "prefix")}"

    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${var.name}"
      log_stream_name = "S3Delivery"
    }
  }
}
