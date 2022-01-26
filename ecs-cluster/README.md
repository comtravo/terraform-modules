## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_ami | The AWS ami id to use | `string` | n/a | yes |
| cluster | The name of the cluster | `string` | n/a | yes |
| cluster\_attributes | The ECS atributes for the cluster | `map(string)` | `{}` | no |
| cluster\_uid | The name of the cluster | `string` | n/a | yes |
| custom\_userdata | Inject extra command in the instance template to be run on boot | `string` | `""` | no |
| depends\_id | Inter module dependency hack | `string` | n/a | yes |
| desired\_capacity | The desired capacity of the cluster | `number` | `1` | no |
| ebs\_root\_volume\_size | Size of the root volume in GB | `number` | n/a | yes |
| ecs\_logging | Adding logging option to ECS. | `list(string)` | <pre>[<br>  "json-file",<br>  "awslogs",<br>  "gelf",<br>  "syslog"<br>]</pre> | no |
| environment | The name of the environment | `string` | n/a | yes |
| fleet\_config | n/a | `map(string)` | n/a | yes |
| iam\_instance\_profile\_id | The id of the instance profile that should be used for the instances | `string` | n/a | yes |
| instance\_override | n/a | <pre>list(object({<br>    instance_type     = string<br>    weighted_capacity = number<br>  }))</pre> | n/a | yes |
| key\_name | SSH key name to be used | `string` | n/a | yes |
| launch\_template\_event\_emitter\_role | IAM role to assume while emitting launch template changes | `string` | n/a | yes |
| max\_size | Maximum size of the nodes in the cluster | `number` | `1` | no |
| min\_size | Minimum size of the nodes in the cluster | `number` | `10` | no |
| region | AWS\_REGION to emit cloudwatch event for updating launch configuration | `string` | n/a | yes |
| scale\_out | Scale out type. Defaults to MemoryReservation and threshold of 65% | `map(string)` | <pre>{<br>  "adjustment": 1,<br>  "cooldown": 300,<br>  "evaluation_periods": 2,<br>  "threshold": 65,<br>  "type": "MemoryReservation"<br>}</pre> | no |
| security\_group\_ids | The list of security groups to place the instances in | `list(string)` | n/a | yes |
| subnet\_ids | The list of subnets to place the instances in | `list(string)` | n/a | yes |
| vpc\_id | The VPC id | `string` | n/a | yes |

## Outputs

No output.
