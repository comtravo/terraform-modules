variable "name" {
  description = "AWS ALB name"
}

variable "enable" {
  description = "int flag to enable or disable this module. Should be 0 or 1 for this module to work properly"
  default     = 1
}

variable "vpc_id" {
  description = "VPC ID where the ALB needs to be provisioned"
}

variable "internal" {
  description = "Bool flag to indicate whether the ALB is internal or external"
}

variable "load_balancer_type" {
  default = "application"
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

# Terraform list of maps
# https://github.com/hashicorp/terraform/issues/12294

variable "https_listeners" {
  description = "List of maps of HTTPS listenr objects"
  type        = map(string)
  default     = {}
}

variable "http_listeners" {
  description = "List of maps of HTTPS listenr objects"
  type        = list(string)
  default     = []
}

variable "health_check" {
  description = "Healthcheck for default target groups"
  type        = map(string)
  default     = {}
}
