variable "name" {
  description = "AWS ALB name"
  type        = string
}

variable "enable" {
  description = "Enable or Disable module"
  default     = true
  type        = bool
}

variable "enable_deletion_protection" {
  description = "Enable or Disable deletion protection"
  default     = true
  type        = bool
}

locals {
  enable_count = var.enable ? 1 : 0
}

variable "vpc_id" {
  description = "VPC ID where the ALB needs to be provisioned"
  type        = string
}

variable "internal" {
  description = "Bool flag to indicate whether the ALB is internal or external"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "List of security groups to be associated with the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnets IDs where the ALB would be serving"
  type        = list(string)
}

variable "idle_timeout" {
  description = "Idle timeout"
  default     = 60
  type        = number
}

variable "ip_address_type" {
  description = "Address type for the ALB. Can be ipv4 or dual"
  default     = "ipv4"
  type        = string
}

variable "environment" {
  description = "The environment of the ALB. Used for tagging"
  type        = string
}

variable "timeouts" {
  description = "ALB creation timeouts"
  type = object({
    create = string,
    delete = string,
    update = string
  })

  default = {
    create = "10m"
    delete = "10m"
    update = "10m"
  }
}

variable "https_listener_config" {
  description = "List of maps of HTTPS listenr objects"
  type = object({
    port                   = string,
    certificates           = list(string),
    number_of_certificates = number
  })
  default = null
}

variable "http_listener_port" {
  description = " HTTP listener port"
  type        = number
  default     = 80
}

variable "health_check" {
  description = "Healthcheck for default target groups"
  type        = map(string)
  default     = {}
}

variable "access_logs" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#access_logs"
  type        = map
  default     = {}
}
