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
| [aws_route53_record.srv](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.txt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hostname"></a> [hostname](#input\_hostname) | MongoDB replicaset hostname | `string` | n/a | yes |
| <a name="input_members"></a> [members](#input\_members) | Members of the mongoDB replicaset | <pre>list(object({<br>    hostname = string<br>    port     = string<br>    priority = number<br>    weight   = number<br>  }))</pre> | n/a | yes |
| <a name="input_txt_records"></a> [txt\_records](#input\_txt\_records) | MongoDB replicaset TXT records | `list(string)` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | AWS R53 Zone ID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_srv"></a> [srv](#output\_srv) | SRV record |
| <a name="output_txt"></a> [txt](#output\_txt) | TXT record |
