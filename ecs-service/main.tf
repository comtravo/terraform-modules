resource "aws_ecs_task_definition" "service" {
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

resource "aws_iam_role_policy_attachment" "ecs_service_role" {
  role       = aws_iam_role.ecs_service_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_ecs_service" "service" {
  name                               = var.name
  cluster                            = var.cluster_name
  task_definition                    = aws_ecs_task_definition.service.arn
  launch_type                        = var.launch_type
  desired_count                      = var.capacity.desired
  iam_role                           = aws_iam_role.eecs_service_role.arn
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

  dynamic "load_balancer" {
    for_each = var.load_balancer != null ? [var.load_balancer] : []
    content {
      target_group_arn = aws_lb_target_group.service[load_balancer.key].arn
      container_name   = var.name
      container_port   = load_balancer.value.container_port
    }
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_lb_target_group" "service" {
  for_each = var.load_balancer != null ? [var.load_balancer] : []

  name                          = var.name
  port                          = each.value.container_port
  protocol                      = each.value.protocol
  vpc_id                        = var.vpc_id
  deregistration_delay          = each.value.deregistration_delay
  load_balancing_algorithm_type = each.value.load_balancing_algorithm_type

  health_check {
    enabled             = each.value.health_check.enabled
    healthy_threshold   = each.value.health_check.healthy_threshold
    unhealthy_threshold = each.value.health_check.unhealthy_threshold
    matcher             = each.value.health_check.matcher
    interval            = each.value.health_check.interval
    path                = each.value.health_check.path
    port                = each.value.health_check.port
    protocol            = each.value.health_check.protocol
    timeout             = each.value.health_check.timeout
  }

  dynamic "stickiness" {
    for_each = each.value.stickiness != null ? [each.value.stickiness] : []
    content {
      type            = stickiness.value.type
      enabled         = stickiness.value.enabled
      cookie_duration = stickiness.value.cookie_duration
      cookie_name     = stickiness.value.cookie_name
    }
  }

  tags = var.tags
}

resource "aws_lb_listener_rule" "service" {
  for_each = aws_lb_target_group.service

  listener_arn = var.load_balancers[each.key].listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service[each.key].arn
  }


  dynamic "condition" {
    for_each = each.value.condition_host_header_values != null ? [each.value.condition_host_header_values] : []
    content {
      host_header {
        values = condition.value
      }
    }
  }

  dynamic "condition" {
    for_each = each.value.condition_path_pattern_values != null ? [each.value.condition_path_pattern_values] : []
    content {
      path_pattern {
        values = condition.value
      }
    }
  }

  tags = var.tags
}

resource "aws_route53_record" "this" {
  for_each = toset([for loadbalancer in var.load_balancer : load_balancer.aws_route53_record])

  zone_id = each.value.zone_id
  name    = each.value.name
  type    = each.value.type

  alias {
    name                   = each.value.alias_name
    zone_id                = each.value.alias_zone_id
    evaluate_target_health = each.value.evaluate_target_health
  }
}

output "target_group" {
  value       = aws_lb_target_group.service
  description = "LB target group attributes"
}
