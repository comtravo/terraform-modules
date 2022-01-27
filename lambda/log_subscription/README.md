## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_log\_subscription | Lambda CloudWatch log subscription | <pre>object({<br>    filter_pattern : string<br>    destination_arn : string<br>  })</pre> | n/a | yes |
| enable | Enable this module | `bool` | `false` | no |
| lambda\_name | Lambda name | `string` | n/a | yes |
| log\_group\_name | Lambda log group name | `string` | n/a | yes |

## Outputs

No output.
