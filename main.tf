/**
* # Terraform AWS module for [AWS API gateway V2](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html) with OpenAPI spec
*
* ## Introduction
* This is a minimal Terraform module which accepts a AWS + OpenAPI spec and deploys an [AWS API Gateway V2](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html)
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


resource "aws_apigatewayv2_api" "this" {
  name               = var.name
  protocol_type      = var.protocol_type
  description        = "${var.name} API Integration"
  cors_configuration = var.cors_configuration
  body               = var.body
  version            = sha256(var.body)
  tags               = var.tags
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
  tags          = var.tags
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

# resource "aws_apigatewayv2_api_mapping" "this" {
#   count       = var.domain_settings.enable == true ? 1 : 0

#   api_id      = aws_apigatewayv2_api.this.id
#   stage_name  = aws_apigatewayv2_stage.this.name
#   domain_name = aws_apigatewayv2_domain_name.this[0].domain_name
#   base_path   = aws_api_gateway_rest_api.api.name
# }
