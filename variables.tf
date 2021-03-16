variable "name" {
  description = "Name of the API gateway deployment"
  type        = string
}

variable "protocol_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#protocol_type"
  type        = string
}

variable "body" {
  description = "Definition of the API Gateway"
  type        = string
}

variable "stage" {
  description = "Name of the stage to which deployed"
  type        = string
}

variable "tags" {
  default     = {}
  description = "Tags for resources"
  type        = map
}

variable "cors_configuration" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#cors_configuration"
  type = list(object({
    allow_credentials = bool
    allow_headers     = list(string)
    allow_methods     = list(string)
    allow_origins     = list(string)
    expose_headers    = list(string)
    max_age           = number
  }))
  default = []
}

variable "access_log_settings" {
  type = object({
    format            = string
    retention_in_days = number
  })
  default = {
    format            = "{ \"requestId\":\"$context.requestId\", \"ip\": \"$context.identity.sourceIp\", \"requestTime\":\"$context.requestTime\", \"httpMethod\":\"$context.httpMethod\",\"routeKey\":\"$context.routeKey\", \"status\":\"$context.status\",\"protocol\":\"$context.protocol\", \"responseLength\":\"$context.responseLength\" }"
    retention_in_days = 90
  }
  description = "https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html#apigateway-cloudwatch-log-formats"
}

variable "domain_settings" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name"
  type = object({
    enable          = bool
    domain_name     = string
    zone_id         = string
    certificate_arn = string
    endpoint_type   = string
    security_policy = string
  })

  default = {
    enable          = false
    zone_id         = ""
    domain_name     = ""
    certificate_arn = ""
    endpoint_type   = ""
    security_policy = ""
  }
}
