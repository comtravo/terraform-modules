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

variable "domain_name" {
  default     = ""
  description = "Custom domain name"
  type        = string
}


variable "tags" {
  default     = {}
  description = "Tags for resources"
  type        = map
}

variable "cors_configuration" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api#cors_configuration"
  type        = map
  default     = {}
}

variable "access_log_settings" {
  type = object({
    enable = bool
    format = string
  })
  default = {
    enable = true
    format = "JSON"
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
