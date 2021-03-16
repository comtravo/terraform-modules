variable "name" {
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

resource "aws_iam_role" "lambda" {
  name                  = var.name
  assume_role_policy    = data.aws_iam_policy_document.assume_role.json
  force_detach_policies = true
}

module "apig_lambda" {

  source = "github.com/comtravo/terraform-aws-lambda?ref=5.0.0"

  file_name     = "${path.root}/foo.zip"
  function_name = var.name
  handler       = "index.handler"
  role          = aws_iam_role.lambda.arn
  trigger = {
    type = "api-gateway"
  }
  environment = {
    "LOREM" = "IPSUM"
  }
  region = "us-east-1"
  tags = {
    "Foo" : var.name
  }
}

module "apig" {
  source = "../../"

  name          = var.name
  stage         = var.name
  protocol_type = "HTTP"
  tags = {
    Name        = var.name
    environment = "automates testing"
  }
  body = <<EOF
---
openapi: "3.0.1"
x-amazon-apigateway-importexport-version: "1.0"
info:
  title: "test"
paths:
  /lambda:
    x-amazon-apigateway-any-method:
      responses:
        default:
          description: "Default response for ANY /lambda"
      x-amazon-apigateway-integration:
        payloadFormatVersion: "2.0"
        type: "aws_proxy"
        httpMethod: "POST"
        uri: "${module.apig_lambda.invoke_arn}"
        connectionType: "INTERNET"
EOF
}

output "aws_apigatewayv2_api" {
  value = module.apig.aws_apigatewayv2_api
}

output "aws_apigatewayv2_deployment" {
  value = module.apig.aws_apigatewayv2_deployment
}

output "aws_apigatewayv2_stage" {
  value = module.apig.aws_apigatewayv2_stage
}

output "aws_apigatewayv2_domain_name" {
  value = module.apig.aws_apigatewayv2_domain_name
}

output "aws_route53_record" {
  value = module.apig.aws_route53_record
}

output "aws_cloudwatch_log_group" {
  value = module.apig.aws_cloudwatch_log_group
}
