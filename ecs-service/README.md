## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener_rule.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_alb_target_group.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_appautoscaling_policy.ecs_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_ecs_service.daemon](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_lb_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_lb_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_route53_record.internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb"></a> [alb](#input\_alb) | ECS service ALB configuration | <pre>list(object({<br>    pattern      = string<br>    listener_arn = string<br>  }))</pre> | `[]` | no |
| <a name="input_alb_listener_count"></a> [alb\_listener\_count](#input\_alb\_listener\_count) | Number of ALB load balancers | `number` | `0` | no |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | ECS service capacity | <pre>object({<br>    min            = number<br>    max            = number<br>    desired        = number<br>    enable_scaling = bool<br>    target_value   = number<br>  })</pre> | n/a | yes |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | ECS cluster id | `string` | n/a | yes |
| <a name="input_container_definition"></a> [container\_definition](#input\_container\_definition) | ECS container definition | `string` | n/a | yes |
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | Deregistration delay | `number` | `60` | no |
| <a name="input_ecs_autoscaling_service_linked_role"></a> [ecs\_autoscaling\_service\_linked\_role](#input\_ecs\_autoscaling\_service\_linked\_role) | ECS autoscaling service linked role | `string` | `""` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable module | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | task execution role arn | `string` | `null` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Force new deployment | `bool` | `false` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | n/a | `map(string)` | `{}` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | n/a | `string` | `""` | no |
| <a name="input_load_balancing_algorithm_type"></a> [load\_balancing\_algorithm\_type](#input\_load\_balancing\_algorithm\_type) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#load_balancing_algorithm_type | `string` | `"least_outstanding_requests"` | no |
| <a name="input_max_healthy_percent"></a> [max\_healthy\_percent](#input\_max\_healthy\_percent) | Maximum healthy percentage | `number` | `null` | no |
| <a name="input_min_healthy_percent"></a> [min\_healthy\_percent](#input\_min\_healthy\_percent) | Minimum healthy percentage | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ECS service name | `string` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Service network mode | `string` | `"bridge"` | no |
| <a name="input_placement_constraints"></a> [placement\_constraints](#input\_placement\_constraints) | ECS service contraints | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| <a name="input_placement_strategy"></a> [placement\_strategy](#input\_placement\_strategy) | ECS service placement strategy | <pre>list(object({<br>    field = string<br>    type  = string<br>  }))</pre> | <pre>[<br>  {<br>    "field": "attribute:ecs.availability-zone",<br>    "type": "spread"<br>  },<br>  {<br>    "field": "memory",<br>    "type": "binpack"<br>  }<br>]</pre> | no |
| <a name="input_port_mappings"></a> [port\_mappings](#input\_port\_mappings) | ECS port mappings | <pre>list(object({<br>    hostPort      = number<br>    containerPort = number<br>    protocol      = string<br>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_route53"></a> [route53](#input\_route53) | ECS service R53 configuration | <pre>list(object({<br>    zone_id                = string<br>    name                   = string<br>    type                   = string<br>    alias_name             = string<br>    alias_zone_id          = string<br>    evaluate_target_health = bool<br>  }))</pre> | `[]` | no |
| <a name="input_route53_count"></a> [route53\_count](#input\_route53\_count) | Number of R53 records | `number` | `0` | no |
| <a name="input_scheduling_strategy"></a> [scheduling\_strategy](#input\_scheduling\_strategy) | n/a | `string` | `"REPLICA"` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | task role arn | `string` | n/a | yes |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | ECS task volumes | <pre>list(object({<br>    name      = string<br>    host_path = string<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_alb_target_group"></a> [aws\_alb\_target\_group](#output\_aws\_alb\_target\_group) | ALB Target Group configuration |
| <a name="output_capacity"></a> [capacity](#output\_capacity) | Capacity configuration |
