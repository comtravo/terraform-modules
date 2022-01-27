## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable\_cross\_zone\_load\_balancing | Whether the loadbalancer should have cross zone load balancing enabled | `bool` | `true` | no |
| enable\_deletion\_protection | Whether the loadbalancer should have delete protection enabled | `bool` | `true` | no |
| internal | Whether the loadbalancer is internal or not | `bool` | n/a | yes |
| name | The name of the loadbalancer | `string` | n/a | yes |
| subnets | The subnets to attach to the loadbalancer | `list(string)` | n/a | yes |
| tags | Tags to apply to the loadbalancer | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| output | Loadbalancer attributes |
