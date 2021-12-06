## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_cross_zone_load_balancing"></a> [enable\_cross\_zone\_load\_balancing](#input\_enable\_cross\_zone\_load\_balancing) | Whether the loadbalancer should have cross zone load balancing enabled | `bool` | `true` | no |
| <a name="input_enable_delete_protection"></a> [enable\_delete\_protection](#input\_enable\_delete\_protection) | Whether the loadbalancer should have delete protection enabled | `bool` | `true` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Whether the loadbalancer is internal or not | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the loadbalancer | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The subnets to attach to the loadbalancer | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the loadbalancer | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_output"></a> [output](#output\_output) | Loadbalancer attributes |
