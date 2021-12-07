resource "aws_ecs_task_definition" "this" {
  family                = var.name
  container_definitions = var.container_definitions
  task_role_arn         = var.task_role_arn
  execution_role_arn    = var.execution_role_arn
  network_mode          = var.network_mode

  dynamic "volume" {
    for_each = var.volumes
    content {
      host_path = volume.value.host_path
      name      = volume.value.name
    }
  }

  tags = var.tags
}

resource "aws_iam_role" "ecs_service_role" {
  name                  = "${var.name}-ecs-role"
  force_detach_policies = true

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_service_linked_role" {
  role       = aws_iam_role.ecs_service_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_ecs_service" "service" {
  name                               = var.name
  cluster                            = var.cluster_name
  task_definition                    = aws_ecs_task_definition.this.arn
  launch_type                        = var.launch_type
  desired_count                      = var.capacity.desired
  iam_role                           = aws_iam_role.ecs_service_role.arn
  deployment_maximum_percent         = var.deployment_percent.max_percent
  deployment_minimum_healthy_percent = var.deployment_percent.min_healthy_percent
  force_new_deployment               = var.force_new_deployment
  scheduling_strategy                = var.scheduling_strategy
  enable_ecs_managed_tags            = var.enable_ecs_managed_tags
  propagate_tags                     = var.propagate_tags
  wait_for_steady_state              = var.wait_for_steady_state

  dynamic "ordered_placement_strategy" {
    for_each = var.placement_strategy
    content {
      field = ordered_placement_strategy.value.field
      type  = ordered_placement_strategy.value.type
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      expression = placement_constraints.value.expression
      type       = placement_constraints.value.type
    }
  }

  tags = var.tags

  load_balancer {
    target_group_arn = aws_lb_target_group.service.arn
    container_name   = var.name
    container_port   = var.load_balancer.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_lb_target_group" "service" {
  name                          = var.name
  port                          = var.load_balancer.container_port
  protocol                      = var.load_balancer.protocol
  vpc_id                        = var.vpc_id
  deregistration_delay          = var.load_balancer.deregistration_delay
  load_balancing_algorithm_type = var.load_balancer.load_balancing_algorithm_type

  health_check {
    healthy_threshold   = var.load_balancer.health_check.healthy_threshold
    unhealthy_threshold = var.load_balancer.health_check.unhealthy_threshold
    interval            = var.load_balancer.health_check.interval
    port                = var.load_balancer.health_check.port
    protocol            = var.load_balancer.health_check.protocol
    timeout             = var.load_balancer.health_check.timeout
  }

  stickiness {
    type    = "source_ip"
    enabled = true
  }

  tags = var.tags
}

resource "aws_lb_listener" "service" {
  load_balancer_arn = var.load_balancer.load_balancer_arn
  port              = var.load_balancer.container_port
  protocol          = var.load_balancer.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }

  tags = var.tags
}

resource "aws_lb_listener_rule" "service" {
  for_each = aws_lb_target_group.service

  listener_arn = aws_lb_listener.service.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service.arn
  }

  condition {
    host_header {
      values = [for record in var.load_balancer.aws_route53_records : record.name]
    }
  }

  tags = var.tags
}

resource "aws_route53_record" "this" {
  for_each = toset(var.load_balancer.aws_route53_records)

  zone_id = each.value.zone_id
  name    = each.value.name
  type    = each.value.type

  alias {
    name                   = each.value.alias_name
    zone_id                = each.value.alias_zone_id
    evaluate_target_health = each.value.evaluate_target_health
  }
}

output "aws_ecs_service" {
  value       = aws_ecs_service.service
  description = "AWS ECS service attributes"
}

output "aws_ecs_task_definition" {
  value       = aws_ecs_task_definition.this
  description = "AWS ECS task definition attributes"
}

output "target_group" {
  value       = aws_lb_target_group.service
  description = "LB target group attributes"
}

output "aws_lb_listener" {
  value       = aws_lb_listener.service
  description = "LB listener attributes"
}
