/**
* # Terraform AWS module for [AWS API gateway V2](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html) with OpenAPI spec
*
* ## Introduction
* This is a minimal Terraform module which accepts a AWS + OpenAPI spec and deploys an [AWS API Gateway V2](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api.html)
*
* ## Usage
* Check [examples](./examples) on how to use this module
*
* ## Authors
*
* Module managed by [Comtravo](https://github.com/comtravo).
*
* License
* -------
*
* MIT Licensed. See [LICENSE](LICENSE) for full details.
*/

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/apigateway/${var.name}"
  retention_in_days = var.access_log_settings.retention_in_days

  tags = var.tags
}
resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  protocol_type = var.protocol_type
  description   = "${var.name} API Integration"
  body          = var.body
  version       = sha256(var.body)

  dynamic cors_configuration {
    for_each = var.cors_configuration
    content {
      allow_credentials = cors_configuration.value["allow_credentials"]
      allow_headers     = cors_configuration.value["allow_headers"]
      allow_methods     = cors_configuration.value["allow_methods"]
      allow_origins     = cors_configuration.value["allow_origins"]
      expose_headers    = cors_configuration.value["expose_headers"]
      max_age           = cors_configuration.value["max_age"]
    }
  }
  tags = var.tags
}

resource "aws_apigatewayv2_deployment" "this" {
  api_id      = aws_apigatewayv2_api.this.id
  description = "${var.name} API deployment"

  triggers = {
    "redeployment" = sha256(var.body)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_apigatewayv2_stage" "this" {
  api_id        = aws_apigatewayv2_api.this.id
  name          = var.stage
  description   = "${var.name} API stage: ${var.stage}"
  deployment_id = aws_apigatewayv2_deployment.this.id
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn
    format          = var.access_log_settings.format
  }
  tags = var.tags
}

resource "aws_apigatewayv2_domain_name" "this" {
  count = var.domain_settings.enable == true ? 1 : 0

  domain_name = var.domain_settings.domain_name

  domain_name_configuration {
    certificate_arn = var.domain_settings.certificate_arn
    endpoint_type   = var.domain_settings.endpoint_type
    security_policy = var.domain_settings.security_policy
  }

  tags = var.tags
}

resource "aws_route53_record" "this" {
  count   = var.domain_settings.enable == true ? 1 : 0
  name    = aws_apigatewayv2_domain_name.this[0].domain_name
  type    = "A"
  zone_id = var.domain_settings.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
