provider "aws" {
  s3_force_path_style         = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  access_key                  = "This is not an actual access key."
  secret_key                  = "This is not an actual secret key."

  endpoints {
    apigateway     = "http://localstack:4567"
    cloudformation = "http://localstack:4581"
    cloudwatch     = "http://localstack:4582"
    dynamodb       = "http://localstack:4569"
    es             = "http://localstack:4578"
    firehose       = "http://localstack:4573"
    iam            = "http://localstack:4593"
    kinesis        = "http://localstack:4568"
    lambda         = "http://localstack:4574"
    route53        = "http://localstack:4580"
    redshift       = "http://localstack:4577"
    s3             = "http://localstack:4572"
    secretsmanager = "http://localstack:4584"
    ses            = "http://localstack:4579"
    sns            = "http://localstack:4575"
    sqs            = "http://localstack:4576"
    ssm            = "http://localstack:4583"
    stepfunctions  = "http://localstack:4585"
    sts            = "http://localstack:4592"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket"
  acl    = "private"
}


module "firehose_enabled" {
  source = "../"

  enable = true

  name        = "firehose_enabled"
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
  destination = "s3"

  s3_configuration = {
    bucket_arn      = aws_s3_bucket.b.arn
    prefix          = "prefix/"
    buffer_interval = 300
    buffer_size     = 5
  }
}

output "firehose_enabled" {
  value = module.firehose_enabled.arn
}

module "firehose_disabled" {
  source = "../"

  enable = false

  name        = "firehose_disabled"
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.name
  destination = "s3"

  s3_configuration = {
    bucket_arn      = aws_s3_bucket.b.arn
    prefix          = "prefix/"
    buffer_interval = 300
    buffer_size     = 5
  }
}

output "firehose_disabled" {
  value = module.firehose_disabled.arn
}
