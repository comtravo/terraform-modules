## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_route53\_records | Route53 records to create | <pre>list(object({<br>    zone_id = string<br>    name    = string<br>    type    = string<br>    alias = object({<br>      name                   = string<br>      zone_id                = string<br>      evaluate_target_health = bool<br>    })<br>  }))</pre> | n/a | yes |
| capacity | ECS service capacity | <pre>object({<br>    min            = number<br>    max            = number<br>    desired        = number<br>    enable_scaling = bool<br>    target_value   = number<br>  })</pre> | n/a | yes |
| cluster\_name | Name of the ECS cluster | `string` | n/a | yes |
| container\_definitions | ECS container definition | `string` | n/a | yes |
| deployment\_percent | ECS deployment healthy percentage | <pre>object({<br>    max_percent         = number<br>    min_healthy_percent = number<br>  })</pre> | <pre>{<br>  "max_percent": 100,<br>  "min_healthy_percent": 0<br>}</pre> | no |
| enable\_ecs\_managed\_tags | Enable ECS managed tags | `bool` | `true` | no |
| execution\_role\_arn | ECS task execution role arn | `string` | `null` | no |
| force\_new\_deployment | Force new deployment | `bool` | `false` | no |
| launch\_type | ECS service launch type | `string` | `"EC2"` | no |
| load\_balancer | Target groups to create and attach to the load balancer | <pre>map(object({<br>    load_balancer_arn    = string<br>    deregistration_delay = number<br>    container_port       = number<br>    protocol             = string<br>    health_check = object({<br>      healthy_threshold   = number<br>      interval            = number<br>      port                = number<br>      protocol            = string<br>      timeout             = number<br>      unhealthy_threshold = number<br>    })<br>  }))</pre> | n/a | yes |
| name | Name of the ECS service | `string` | n/a | yes |
| network\_mode | ECS service network mode | `string` | `"bridge"` | no |
| placement\_constraints | ECS service placement contraints | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| placement\_strategy | ECS service placement strategy | <pre>list(object({<br>    field = string<br>    type  = string<br>  }))</pre> | <pre>[<br>  {<br>    "field": "attribute:ecs.availability-zone",<br>    "type": "spread"<br>  },<br>  {<br>    "field": "memory",<br>    "type": "binpack"<br>  }<br>]</pre> | no |
| propagate\_tags | propogate tags from | `string` | `"SERVICE"` | no |
| scheduling\_strategy | ECS service scheduling strategy | `string` | `"REPLICA"` | no |
| tags | ECS tags | `map(string)` | `{}` | no |
| task\_role\_arn | ECS task role arn | `string` | n/a | yes |
| volumes | ECS task volumes | <pre>list(object({<br>    name      = string<br>    host_path = string<br>  }))</pre> | `[]` | no |
| vpc\_id | VPC id | `string` | n/a | yes |
| wait\_for\_steady\_state | Wait for services to be stable | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_ecs\_service | AWS ECS service attributes |
| aws\_ecs\_task\_definition | AWS ECS task definition attributes |
| aws\_lb\_listener | LB listener attributes |
| target\_group | LB target group attributes |
