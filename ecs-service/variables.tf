variable "name" {
  description = "Name of the ECS service"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "launch_type" {
  description = "ECS service launch type"
  type        = string
  default     = "EC2"
}

variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "network_mode" {
  default     = "bridge"
  type        = string
  description = "ECS service network mode"
}

variable "container_definitions" {
  type        = string
  description = "ECS container definition"
}

variable "task_role_arn" {
  type        = string
  description = "ECS task role arn"
}

variable "execution_role_arn" {
  default     = null
  type        = string
  description = "ECS task execution role arn"
}

variable "force_new_deployment" {
  type        = bool
  default     = false
  description = "Force new deployment"
}

variable "enable_ecs_managed_tags" {
  type        = bool
  default     = true
  description = "Enable ECS managed tags"
}

variable "wait_for_steady_state" {
  type        = bool
  default     = true
  description = "Wait for services to be stable"
}

variable "propagate_tags" {
  type        = string
  default     = "SERVICE"
  description = "propogate tags from"
}

variable "volumes" {
  type = list(object({
    name      = string
    host_path = string
  }))
  default     = []
  description = "ECS task volumes"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "ECS tags"
}

variable "placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  default     = []
  description = "ECS service placement contraints"
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

variable "scheduling_strategy" {
  default     = "REPLICA"
  type        = string
  description = "ECS service scheduling strategy"
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

variable "deployment_percent" {
  type = object({
    max_percent         = number
    min_healthy_percent = number
  })
  description = "ECS deployment healthy percentage"
  default = {
    max_percent         = 100
    min_healthy_percent = 0
  }
}

variable "load_balancer" {
  description = "Target groups to create and attach to the load balancer"
  type = object({
    load_balancer_arn             = string
    deregistration_delay          = number
    container_port                = number
    protocol                      = string
    health_check = object({
      healthy_threshold   = number
      interval            = number
      port                = number
      protocol            = string
      timeout             = number
      unhealthy_threshold = number
    })
    aws_route53_records = list(object({
      zone_id = string
      name    = string
      type    = string
      alias = object({
        name                   = string
        zone_id                = string
        evaluate_target_health = bool
      })
    }))
  })
}
