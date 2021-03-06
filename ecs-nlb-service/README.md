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
| [aws_ecs_service.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_lb_listener.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_route53_records"></a> [aws\_route53\_records](#input\_aws\_route53\_records) | Route53 records to create | <pre>list(object({<br>    zone_id = string<br>    name    = string<br>    type    = string<br>    alias = object({<br>      name                   = string<br>      zone_id                = string<br>      evaluate_target_health = bool<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_capacity"></a> [capacity](#input\_capacity) | ECS service capacity | <pre>object({<br>    min            = number<br>    max            = number<br>    desired        = number<br>    enable_scaling = bool<br>    target_value   = number<br>  })</pre> | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the ECS cluster | `string` | n/a | yes |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | ECS container definition | `string` | n/a | yes |
| <a name="input_deployment_percent"></a> [deployment\_percent](#input\_deployment\_percent) | ECS deployment healthy percentage | <pre>object({<br>    max_percent         = number<br>    min_healthy_percent = number<br>  })</pre> | <pre>{<br>  "max_percent": 100,<br>  "min_healthy_percent": 0<br>}</pre> | no |
| <a name="input_enable_ecs_managed_tags"></a> [enable\_ecs\_managed\_tags](#input\_enable\_ecs\_managed\_tags) | Enable ECS managed tags | `bool` | `true` | no |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | ECS task execution role arn | `string` | `null` | no |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | Force new deployment | `bool` | `false` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | ECS service launch type | `string` | `"EC2"` | no |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | Target groups to create and attach to the load balancer | <pre>map(object({<br>    load_balancer_arn    = string<br>    deregistration_delay = number<br>    container_port       = number<br>    protocol             = string<br>    health_check = object({<br>      healthy_threshold   = number<br>      interval            = number<br>      port                = number<br>      protocol            = string<br>      timeout             = number<br>      unhealthy_threshold = number<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the ECS service | `string` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | ECS service network mode | `string` | `"bridge"` | no |
| <a name="input_placement_constraints"></a> [placement\_constraints](#input\_placement\_constraints) | ECS service placement contraints | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| <a name="input_placement_strategy"></a> [placement\_strategy](#input\_placement\_strategy) | ECS service placement strategy | <pre>list(object({<br>    field = string<br>    type  = string<br>  }))</pre> | <pre>[<br>  {<br>    "field": "attribute:ecs.availability-zone",<br>    "type": "spread"<br>  },<br>  {<br>    "field": "memory",<br>    "type": "binpack"<br>  }<br>]</pre> | no |
| <a name="input_propagate_tags"></a> [propagate\_tags](#input\_propagate\_tags) | propogate tags from | `string` | `"SERVICE"` | no |
| <a name="input_scheduling_strategy"></a> [scheduling\_strategy](#input\_scheduling\_strategy) | ECS service scheduling strategy | `string` | `"REPLICA"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | ECS tags | `map(string)` | `{}` | no |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | ECS task role arn | `string` | n/a | yes |
| <a name="input_volumes"></a> [volumes](#input\_volumes) | ECS task volumes | <pre>list(object({<br>    name      = string<br>    host_path = string<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |
| <a name="input_wait_for_steady_state"></a> [wait\_for\_steady\_state](#input\_wait\_for\_steady\_state) | Wait for services to be stable | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_ecs_service"></a> [aws\_ecs\_service](#output\_aws\_ecs\_service) | AWS ECS service attributes |
| <a name="output_aws_ecs_task_definition"></a> [aws\_ecs\_task\_definition](#output\_aws\_ecs\_task\_definition) | AWS ECS task definition attributes |
| <a name="output_aws_lb_listener"></a> [aws\_lb\_listener](#output\_aws\_lb\_listener) | LB listener attributes |
| <a name="output_target_group"></a> [target\_group](#output\_target\_group) | LB target group attributes |
