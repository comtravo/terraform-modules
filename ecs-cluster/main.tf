locals {
  name = "${var.cluster}-${var.cluster_uid}"
}

resource "aws_launch_template" "ecs-lc" {
  name_prefix            = local.name
  description            = "ECS launch template for ${local.name}"
  image_id               = var.aws_ami
  vpc_security_group_ids = var.security_group_ids
  user_data              = base64encode(data.template_file.user_data.rendered)
  key_name               = var.key_name
  instance_type          = var.instance_override[0].instance_type

  iam_instance_profile {
    name = var.iam_instance_profile_id
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type           = "gp2"
      volume_size           = var.ebs_root_volume_size
      delete_on_termination = true
    }
  }

  disable_api_termination              = false
  instance_initiated_shutdown_behavior = "terminate"

  lifecycle {
    create_before_destroy = true
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name        = var.cluster
      Environment = var.environment
    }
  }
}

resource "aws_autoscaling_group" "ecs-asg" {
  name_prefix         = local.name
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  force_delete        = true
  vpc_zone_identifier = var.subnet_ids
  capacity_rebalance  = true

  mixed_instances_policy {
    instances_distribution {
      on_demand_percentage_above_base_capacity = var.fleet_config.on_demand_percentage_above_base_capacity
      spot_max_price                           = lookup(var.fleet_config, "spot_max_price", "")
      spot_allocation_strategy                 = "capacity-optimized"
      spot_instance_pools                      = 0
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ecs-lc.id
        version            = aws_launch_template.ecs-lc.latest_version
      }

      dynamic "override" {
        for_each = var.instance_override
        content {
          instance_type     = override.value.instance_type
          weighted_capacity = override.value.weighted_capacity
        }
      }
    }
  }

  tag {
    key                 = "Name"
    value               = var.cluster
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = "true"
  }

  tag {
    key                 = "DependsId"
    value               = var.depends_id
    propagate_at_launch = "false"
  }

  lifecycle {
    # prevent_destroy = true
    # ignore_changes = [
    #   desired_capacity,
    #   max_size,
    # ]
  }
}

resource "aws_autoscaling_policy" "scale-out" {
  name                   = "${local.name}-scale-out"
  autoscaling_group_name = aws_autoscaling_group.ecs-asg.name
  adjustment_type        = "ChangeInCapacity"
  policy_type            = "SimpleScaling"
  cooldown               = var.scale_out.cooldown
  scaling_adjustment     = var.scale_out.adjustment
}

# Used magic formula
resource "aws_cloudwatch_metric_alarm" "scale-out" {
  alarm_name          = "${local.name}-scale-out"
  namespace           = "AWS/ECS"
  metric_name         = var.scale_out.type
  threshold           = var.scale_out.threshold
  period              = "60"
  evaluation_periods  = var.scale_out.evaluation_periods
  statistic           = "Average"
  comparison_operator = "GreaterThanOrEqualToThreshold"

  dimensions = {
    ClusterName = var.cluster
  }

  alarm_description = "Scale out ECS cluster"
  alarm_actions     = [aws_autoscaling_policy.scale-out.arn]
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.sh")

  vars = {
    ecs_logging     = jsonencode(var.ecs_logging)
    cluster_name    = var.cluster
    attributes      = jsonencode(var.cluster_attributes)
    custom_userdata = var.custom_userdata
  }
}

resource "null_resource" "launch-config-update" {
  provisioner "local-exec" {
    command = "AWS_METADATA_SERVICE_TIMEOUT=10 AWS_METADATA_SERVICE_NUM_ATTEMPTS=18 python3 ${path.module}/scripts/emit_launchconfig_event.py --role_to_assume ${var.launch_template_event_emitter_role} --environment ${var.environment} --region ${var.region} --launch_template_id ${aws_launch_template.ecs-lc.id} --launch_template_latest_version ${aws_launch_template.ecs-lc.latest_version} --autoscaling_group_name ${aws_autoscaling_group.ecs-asg.name} --cluster ${var.cluster}"
  }

  triggers = {
    launchTemplateId      = aws_launch_template.ecs-lc.id
    launchTemplateVersion = aws_launch_template.ecs-lc.latest_version
  }
}

