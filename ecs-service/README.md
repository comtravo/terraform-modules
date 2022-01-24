## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb | ECS service ALB configuration | <pre>list(object({<br>    pattern      = string<br>    listener_arn = string<br>  }))</pre> | `[]` | no |
| alb\_listener\_count | Number of ALB load balancers | `number` | `0` | no |
| capacity | ECS service capacity | <pre>object({<br>    min            = number<br>    max            = number<br>    desired        = number<br>    enable_scaling = bool<br>    target_value   = number<br>  })</pre> | n/a | yes |
| cluster\_id | ECS cluster id | `string` | n/a | yes |
| container\_definition | ECS container definition | `string` | n/a | yes |
| deregistration\_delay | Deregistration delay | `number` | `60` | no |
| ecs\_autoscaling\_service\_linked\_role | ECS autoscaling service linked role | `string` | `""` | no |
| enable | Enable module | `bool` | `true` | no |
| environment | Environment | `string` | n/a | yes |
| execution\_role\_arn | task execution role arn | `string` | `null` | no |
| force\_new\_deployment | Force new deployment | `bool` | `false` | no |
| health\_check | n/a | `map(string)` | `{}` | no |
| load\_balancer | n/a | `string` | `""` | no |
| load\_balancing\_algorithm\_type | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#load_balancing_algorithm_type | `string` | `"least_outstanding_requests"` | no |
| max\_healthy\_percent | Maximum healthy percentage | `number` | `null` | no |
| min\_healthy\_percent | Minimum healthy percentage | `number` | `null` | no |
| name | ECS service name | `string` | n/a | yes |
| network\_mode | Service network mode | `string` | `"bridge"` | no |
| placement\_constraints | ECS service contraints | <pre>list(object({<br>    type       = string<br>    expression = string<br>  }))</pre> | `[]` | no |
| placement\_strategy | ECS service placement strategy | <pre>list(object({<br>    field = string<br>    type  = string<br>  }))</pre> | <pre>[<br>  {<br>    "field": "attribute:ecs.availability-zone",<br>    "type": "spread"<br>  },<br>  {<br>    "field": "memory",<br>    "type": "binpack"<br>  }<br>]</pre> | no |
| port\_mappings | ECS port mappings | <pre>list(object({<br>    hostPort      = number<br>    containerPort = number<br>    protocol      = string<br>  }))</pre> | `[]` | no |
| region | AWS region | `string` | n/a | yes |
| route53 | ECS service R53 configuration | <pre>list(object({<br>    zone_id                = string<br>    name                   = string<br>    type                   = string<br>    alias_name             = string<br>    alias_zone_id          = string<br>    evaluate_target_health = bool<br>  }))</pre> | `[]` | no |
| route53\_count | Number of R53 records | `number` | `0` | no |
| scheduling\_strategy | n/a | `string` | `"REPLICA"` | no |
| task\_role\_arn | task role arn | `string` | n/a | yes |
| volumes | ECS task volumes | <pre>list(object({<br>    name      = string<br>    host_path = string<br>  }))</pre> | `[]` | no |
| vpc\_id | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws\_alb\_target\_group | ALB Target Group configuration |
| capacity | Capacity configuration |
