## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ecs-asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_policy.scale-out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy) | resource |
| [aws_cloudwatch_metric_alarm.scale-out](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_launch_template.ecs-lc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [null_resource.launch-config-update](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_ami"></a> [aws\_ami](#input\_aws\_ami) | The AWS ami id to use | `string` | n/a | yes |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | The name of the cluster | `string` | n/a | yes |
| <a name="input_cluster_attributes"></a> [cluster\_attributes](#input\_cluster\_attributes) | The ECS atributes for the cluster | `map(string)` | `{}` | no |
| <a name="input_cluster_uid"></a> [cluster\_uid](#input\_cluster\_uid) | The name of the cluster | `string` | n/a | yes |
| <a name="input_custom_userdata"></a> [custom\_userdata](#input\_custom\_userdata) | Inject extra command in the instance template to be run on boot | `string` | `""` | no |
| <a name="input_depends_id"></a> [depends\_id](#input\_depends\_id) | Inter module dependency hack | `string` | n/a | yes |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | The desired capacity of the cluster | `number` | `1` | no |
| <a name="input_ebs_root_volume_size"></a> [ebs\_root\_volume\_size](#input\_ebs\_root\_volume\_size) | Size of the root volume in GB | `number` | n/a | yes |
| <a name="input_ecs_logging"></a> [ecs\_logging](#input\_ecs\_logging) | Adding logging option to ECS. | `list(string)` | <pre>[<br>  "json-file",<br>  "awslogs",<br>  "gelf",<br>  "syslog"<br>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_fleet_config"></a> [fleet\_config](#input\_fleet\_config) | n/a | `map(string)` | n/a | yes |
| <a name="input_iam_instance_profile_id"></a> [iam\_instance\_profile\_id](#input\_iam\_instance\_profile\_id) | The id of the instance profile that should be used for the instances | `string` | n/a | yes |
| <a name="input_instance_override"></a> [instance\_override](#input\_instance\_override) | n/a | <pre>list(object({<br>    instance_type     = string<br>    weighted_capacity = number<br>  }))</pre> | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | SSH key name to be used | `string` | n/a | yes |
| <a name="input_launch_template_event_emitter_role"></a> [launch\_template\_event\_emitter\_role](#input\_launch\_template\_event\_emitter\_role) | IAM role to assume while emitting launch template changes | `string` | n/a | yes |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum size of the nodes in the cluster | `number` | `1` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum size of the nodes in the cluster | `number` | `10` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS\_REGION to emit cloudwatch event for updating launch configuration | `string` | n/a | yes |
| <a name="input_scale_out"></a> [scale\_out](#input\_scale\_out) | Scale out type. Defaults to MemoryReservation and threshold of 65% | `map(string)` | <pre>{<br>  "adjustment": 1,<br>  "cooldown": 300,<br>  "evaluation_periods": 2,<br>  "threshold": 65,<br>  "type": "MemoryReservation"<br>}</pre> | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | The list of security groups to place the instances in | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The list of subnets to place the instances in | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC id | `string` | n/a | yes |

## Outputs

No outputs.
