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
| environment | The environment of the ALB. Used for tagging | `string` | n/a | yes |
| https\_listener\_config | List of maps of HTTPS listenr objects | <pre>object({<br>    port         = string,<br>    certificates = string<br>  })</pre> | n/a | yes |
| name | AWS ALB name | `string` | n/a | yes |
| security\_group\_ids | List of security groups to be associated with the ALB | `list(string)` | n/a | yes |
| subnet\_ids | List of subnets IDs where the ALB would be serving | `list(string)` | n/a | yes |
| vpc\_id | VPC ID where the ALB needs to be provisioned | `string` | n/a | yes |
| enable | Enable or Disable module | `bool` | `true` | no |
| health\_check | Healthcheck for default target groups | `map(string)` | `{}` | no |
| http\_listener\_port | HTTP listener port | `number` | `80` | no |
| idle\_timeout | Idle timeout | `number` | `60` | no |
| internal | Bool flag to indicate whether the ALB is internal or external | `bool` | `true` | no |
| ip\_address\_type | Address type for the ALB. Can be ipv4 or dual | `string` | `"ipv4"` | no |
| timeouts | n/a | <pre>object({<br>    create = string,<br>    delete = string,<br>    update = string<br>  })</pre> | <pre>{<br>  "create": "10m",<br>  "delete": "10m",<br>  "update": "10m"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | AWS ALB ARN |
| default\_target\_group\_http | default HTTP target group arn |
| default\_target\_group\_https | default HTTPS target group arn |
| dns\_name | AWS ALB DNS name |
| id | AWS ALB id |
| listener\_arns | AWS ALB listner ARNs |
| zone\_id | AWS ALB zone id |

