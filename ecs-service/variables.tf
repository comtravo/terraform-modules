variable "name" {
  type        = string
  description = "ECS service name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "cluster_id" {
  type        = string
  description = "ECS cluster id"
}

locals {
  cluster_name = element(split("/", var.cluster_id), 1)
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "load_balancing_algorithm_type" {
  type        = string
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#load_balancing_algorithm_type"
  default     = "least_outstanding_requests"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "ecs_autoscaling_service_linked_role" {
  default     = ""
  type        = string
  description = "ECS autoscaling service linked role"
}

variable "enable" {
  default     = true
  type        = bool
  description = "Enable module"
}

variable "network_mode" {
  default     = "bridge"
  type        = string
  description = "Service network mode"
}

variable "container_definition" {
  type        = string
  description = "ECS container definition"
}

variable "capacity" {
  type = object({
    min            = number
    max            = number
    desired        = number
    enable_scaling = bool
    target_value   = number
  })
  description = "ECS service capacity"
}

variable "min_healthy_percent" {
  default     = null
  type        = number
  description = "Minimum healthy percentage"
}

variable "max_healthy_percent" {
  default     = null
  type        = number
  description = "Maximum healthy percentage"
}

# list of maps hack
variable "alb" {
  type = list(object({
    pattern      = string
    listener_arn = string
  }))
  default     = []
  description = "ECS service ALB configuration"
}

variable "port_mappings" {
  type = list(object({
    hostPort      = number
    containerPort = number
    protocol      = string
  }))
  default     = []
  description = "ECS port mappings"
}

# https://github.com/hashicorp/terraform/issues/13980#issuecomment-297605688
# Terraform core issue
variable "alb_listener_count" {
  default     = 0
  type        = number
  description = "Number of ALB load balancers"
}

variable "route53_count" {
  default     = 0
  type        = number
  description = "Number of R53 records"
}

# list of maps hack
variable "route53" {
  type = list(object({
    zone_id                = string
    name                   = string
    type                   = string
    alias_name             = string
    alias_zone_id          = string
    evaluate_target_health = bool
  }))
  default     = []
  description = "ECS service R53 configuration"
}

variable "volumes" {
  type = list(object({
    name      = string
    host_path = string
  }))
  default     = []
  description = "ECS task volumes"
}

variable "placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  default     = []
  description = "ECS service contraints"
}

variable "scheduling_strategy" {
  default = "REPLICA"
  type    = string
}

variable "load_balancer" {
  default = ""
  type    = string
}

variable "placement_strategy" {
  description = "ECS service placement strategy"

  type = list(object({
    field = string
    type  = string
  }))

  default = [
    {
      "field" = "attribute:ecs.availability-zone"
      "type"  = "spread"
    },
    {
      "field" = "memory"
      "type"  = "binpack"
    },
  ]
}

variable "task_role_arn" {
  type        = string
  description = "task role arn"
}

variable "execution_role_arn" {
  default     = null
  type        = string
  description = "task execution role arn"
}

variable "health_check" {
  type    = map(string)
  default = {}
}

variable "deregistration_delay" {
  default     = 60
  type        = number
  description = "Deregistration delay"
}

variable "ecs_stability_check_config" {
  description = "Configuration to wait for a service to be stable"
  type = object({
    role     = string
    timeout  = number
    interval = number
  })
}


variable "force_new_deployment" {
  type        = bool
  default     = false
  description = "Force new deployment"
}
