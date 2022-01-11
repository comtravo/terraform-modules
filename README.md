# Comtravo's Terraform AWS ALB module

## Usage:

```hcl
module "website-alb" {
  source = "github.com/comtravo/terraform-aws-alb?ref=3.0.0"

  environment        = terraform.workspace
  name               = "website"
  internal           = false
  vpc_id             = module.main_vpc.vpc_id
  security_group_ids = [aws_security_group.website-alb.id]
  subnet_ids         = module.main_vpc.public_subnets
  idle_timeout       = 120

  http_listener_port = 80

  https_listener_config = {
    port         = 443
    certificates = [
      data.aws_acm_certificate.comtravoDotCom.arn,
      data.aws_acm_certificate.webDotComtravoDotCom.arn,
      data.aws_acm_certificate.comtravoDotDe.arn
    ],
     number_of_certificates = 3
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
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
| [aws_alb.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb) | resource |
| [aws_alb_listener.listener_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.listener_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener_certificate.additional_certificates](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_certificate) | resource |
| [aws_alb_target_group.dummy_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_alb_target_group.dummy_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logs"></a> [access\_logs](#input\_access\_logs) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#access_logs | <pre>list(object({<br>    enabled = bool<br>    bucket  = string<br>    prefix  = string<br>  }))</pre> | `[]` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable or Disable module | `bool` | `true` | no |
| <a name="input_enable_deletion_protection"></a> [enable\_deletion\_protection](#input\_enable\_deletion\_protection) | Enable or Disable deletion protection | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment of the ALB. Used for tagging | `string` | n/a | yes |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Healthcheck for default target groups | `map(string)` | `{}` | no |
| <a name="input_http_listener_port"></a> [http\_listener\_port](#input\_http\_listener\_port) | HTTP listener port | `number` | `80` | no |
| <a name="input_https_listener_config"></a> [https\_listener\_config](#input\_https\_listener\_config) | List of maps of HTTPS listenr objects | <pre>object({<br>    port                   = string,<br>    certificates           = list(string),<br>    number_of_certificates = number<br>  })</pre> | `null` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | Idle timeout | `number` | `60` | no |
| <a name="input_internal"></a> [internal](#input\_internal) | Bool flag to indicate whether the ALB is internal or external | `bool` | `true` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | Address type for the ALB. Can be ipv4 or dual | `string` | `"ipv4"` | no |
| <a name="input_name"></a> [name](#input\_name) | AWS ALB name | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security groups to be associated with the ALB | `list(string)` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnets IDs where the ALB would be serving | `list(string)` | n/a | yes |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | ALB creation timeouts | <pre>object({<br>    create = string,<br>    delete = string,<br>    update = string<br>  })</pre> | <pre>{<br>  "create": "10m",<br>  "delete": "10m",<br>  "update": "10m"<br>}</pre> | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the ALB needs to be provisioned | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | AWS ALB ARN |
| <a name="output_aws_alb"></a> [aws\_alb](#output\_aws\_alb) | AWS ALB attributes |
| <a name="output_aws_alb_listener_http"></a> [aws\_alb\_listener\_http](#output\_aws\_alb\_listener\_http) | AWS ALB HTTPS listener attributes |
| <a name="output_aws_alb_listener_https"></a> [aws\_alb\_listener\_https](#output\_aws\_alb\_listener\_https) | AWS ALB HTTPS listener attributes |
| <a name="output_default_target_group_http"></a> [default\_target\_group\_http](#output\_default\_target\_group\_http) | Default HTTP target group arn |
| <a name="output_default_target_group_https"></a> [default\_target\_group\_https](#output\_default\_target\_group\_https) | Default HTTPS target group arn |
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | AWS ALB DNS name |
| <a name="output_http_listner_arn"></a> [http\_listner\_arn](#output\_http\_listner\_arn) | AWS ALB HTTP listner arn |
| <a name="output_https_listner_arn"></a> [https\_listner\_arn](#output\_https\_listner\_arn) | AWS ALB HTTP listner arn |
| <a name="output_id"></a> [id](#output\_id) | AWS ALB id |
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | AWS ALB zone id |
