variable "name" {
  type        = string
  description = "The name of the loadbalancer"
}

variable "internal" {
  type        = bool
  description = "Whether the loadbalancer is internal or not"
}

variable "subnets" {
  type        = list(string)
  description = "The subnets to attach to the loadbalancer"
}

variable "enable_delete_protection" {
  type        = bool
  description = "Whether the loadbalancer should have delete protection enabled"
  default     = true
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  description = "Whether the loadbalancer should have cross zone load balancing enabled"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the loadbalancer"
  default     = {}
}

resource "aws_lb" "this" {
  name                             = var.name
  internal                         = var.internal
  load_balancer_type               = "network"
  enable_deletion_protection       = var.enable_delete_protection
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  subnets                          = var.subnets
  tags                             = var.tags
}

output "output" {
  value       = aws_lb.this
  description = "Loadbalancer attributes"
}
