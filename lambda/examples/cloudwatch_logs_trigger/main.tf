variable "function_name" {
  type = string
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Do not use the below policy anywhere
data "aws_iam_policy_document" "policy" {
  statement {
    actions   = ["*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "lambda" {
  name                  = var.function_name
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  force_detach_policies = true
}

resource "aws_iam_role_policy" "lambda" {
  name = var.function_name
  role = aws_iam_role.lambda.id

  policy = data.aws_iam_policy_document.policy.json
}


module "logs" {

  source = "../../"

  file_name     = "${path.module}/../../../test/fixtures/foo.zip"
  function_name = var.function_name
  handler       = "index.handler"
  role          = aws_iam_role.lambda.arn

  trigger = {
    type = "cloudwatch-logs"
  }
  environment = {
    "LOREM" = "IPSUM"
  }
  region = "us-east-1"
  tags = {
    "Foo" : var.function_name
  }
}

output "arn" {
  description = "AWS lambda arn"
  value       = module.logs.arn
}

output "qualified_arn" {
  description = "AWS lambda qualified_arn"
  value       = module.logs.qualified_arn
}

output "invoke_arn" {
  description = "AWS lambda invoke_arn"
  value       = module.logs.invoke_arn
}

output "version" {
  description = "AWS lambda version"
  value       = module.logs.version
}

output "dlq" {
  description = "AWS lambda Dead Letter Queue details"
  value       = module.logs.dlq
}

output "queue" {
  description = "AWS lambda SQS details"
  value       = module.logs.queue
}

