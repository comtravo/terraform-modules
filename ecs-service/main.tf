locals {
  default_min_healthy_percent = var.capacity.desired > 1 ? 50 : 0
  default_max_healthy_percent = 100
  min_healthy_percent         = var.min_healthy_percent != null ? var.min_healthy_percent : local.default_min_healthy_percent
  max_healthy_percent         = var.max_healthy_percent != null ? var.max_healthy_percent : local.default_max_healthy_percent

  enable_count         = var.enable ? 1 : 0
  enable_scaling_count = var.enable == true && var.scheduling_strategy == "REPLICA" && var.capacity.enable_scaling == true ? 1 : 0

  service_count           = var.scheduling_strategy == "REPLICA" && var.enable == true ? 1 : 0
  daemon_count            = var.scheduling_strategy == "DAEMON" && var.enable == true ? 1 : 0
  stability_check_command = "AWS_METADATA_SERVICE_TIMEOUT=10 AWS_METADATA_SERVICE_NUM_ATTEMPTS=18 python3 ${path.module}/scripts/wait_for_service_stable.py --region ${var.region} --service ${var.name} --cluster ${var.cluster_id} --role_to_assume ${var.ecs_stability_check_config.role} --service_stability_check_timeout ${var.ecs_stability_check_config.timeout} --interval_between_stability_checks ${var.ecs_stability_check_config.interval}"

  default_tags = {
    Name        = "${var.name}-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_alb_target_group" "service" {
  count                         = local.service_count
  name                          = "${var.name}-${var.environment}"
  port                          = var.port_mappings[0]["containerPort"]
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  deregistration_delay          = var.deregistration_delay
  load_balancing_algorithm_type = var.load_balancing_algorithm_type

  health_check {
    interval            = lookup(var.health_check, "interval", 30)
    path                = lookup(var.health_check, "path", "/")
    healthy_threshold   = lookup(var.health_check, "healthy_threshold", 2)
    unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold", 8)
    timeout             = lookup(var.health_check, "timeout", 5)
    matcher             = lookup(var.health_check, "matcher", 200)
    port                = "traffic-port"
  }

  stickiness {
    type            = "lb_cookie"
    enabled         = true
    cookie_duration = 60
  }

  tags = merge(
    local.default_tags,
    {
      "Loadbalancer" = var.load_balancer
    },
  )
}

resource "aws_ecs_task_definition" "service" {
  count                 = local.enable_count
  family                = "${var.name}-${var.environment}"
  container_definitions = var.container_definition
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

  tags = local.default_tags
}

resource "aws_appautoscaling_target" "ecs_target" {
  count              = local.enable_scaling_count
  max_capacity       = var.capacity.max
  min_capacity       = var.capacity.min
  resource_id        = "service/${local.cluster_name}/${var.name}"
  role_arn           = var.ecs_autoscaling_service_linked_role
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.service]
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  count              = local.enable_scaling_count
  name               = "${local.cluster_name}-${var.name}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/${local.cluster_name}/${var.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    target_value       = var.capacity.target_value
    scale_out_cooldown = 120
    scale_in_cooldown  = 300

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }

  depends_on = [aws_appautoscaling_target.ecs_target]
}

resource "aws_ecs_service" "service" {
  count                              = local.service_count
  name                               = var.name
  cluster                            = var.cluster_id
  task_definition                    = aws_ecs_task_definition.service[0].arn
  launch_type                        = "EC2"
  desired_count                      = var.capacity.desired
  iam_role                           = aws_iam_role.ecs_lb_role[0].arn
  deployment_maximum_percent         = local.max_healthy_percent
  deployment_minimum_healthy_percent = local.min_healthy_percent
  force_new_deployment               = var.force_new_deployment
  dynamic "ordered_placement_strategy" {
    for_each = var.placement_strategy
    content {
      field = ordered_placement_strategy.value.field
      type  = ordered_placement_strategy.value.type
    }
  }
  scheduling_strategy = var.scheduling_strategy
  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      expression = placement_constraints.value.expression
      type       = placement_constraints.value.type
    }
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.service[0].arn
    container_name   = var.name
    container_port   = var.port_mappings[0]["containerPort"]
  }

  depends_on = [
    aws_iam_role.ecs_lb_role,
    aws_ecs_task_definition.service,
  ]

  lifecycle {
    prevent_destroy = true
    ignore_changes  = [desired_count]
  }
}

resource "aws_ecs_service" "daemon" {
  count           = local.daemon_count
  name            = var.name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.service[0].arn
  launch_type     = "EC2"

  scheduling_strategy = var.scheduling_strategy

  depends_on = [
    aws_iam_role.ecs_lb_role,
    aws_ecs_task_definition.service,
  ]


}

resource "aws_alb_listener_rule" "service" {
  count        = local.enable_count * var.alb_listener_count
  listener_arn = var.alb[count.index]["listener_arn"]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service[0].arn
  }

  condition {
    host_header {
      values = [
        var.alb[count.index]["pattern"]
      ]
    }
  }


}

resource "aws_iam_role" "ecs_lb_role" {
  count                 = local.enable_count
  name                  = "${var.name}-alb-role-${var.environment}"
  path                  = "/${var.environment}/"
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

resource "aws_iam_role_policy_attachment" "ecs_lb_role" {
  count      = local.enable_count
  role       = aws_iam_role.ecs_lb_role[0].id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_route53_record" "internal" {
  count   = local.enable_count * var.route53_count
  zone_id = var.route53[count.index]["zone_id"]
  name    = var.route53[count.index]["name"]
  type    = "A"

  alias {
    name                   = var.route53[count.index]["alias_name"]
    zone_id                = var.route53[count.index]["alias_zone_id"]
    evaluate_target_health = var.route53[count.index]["evaluate_target_health"]
  }
}

resource "null_resource" "wait_for_service_deploy" {
  count = local.service_count

  triggers = {
    task_definition = aws_ecs_service.service[0].task_definition
  }

  provisioner "local-exec" {
    command = local.stability_check_command
  }
}

resource "null_resource" "wait_for_daemon_deploy" {
  count = local.daemon_count

  triggers = {
    task_definition = aws_ecs_service.daemon[0].task_definition
  }

  provisioner "local-exec" {
    command = local.stability_check_command
  }
}

