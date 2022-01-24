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
| terraform | >= 0.13 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_logs | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#access_logs | <pre>list(object({<br>    enabled = bool<br>    bucket  = string<br>    prefix  = string<br>  }))</pre> | `[]` | no |
| enable | Enable or Disable module | `bool` | `true` | no |
| enable\_deletion\_protection | Enable or Disable deletion protection | `bool` | `true` | no |
| environment | The environment of the ALB. Used for tagging | `string` | n/a | yes |
| health\_check | Healthcheck for default target groups | `map(string)` | `{}` | no |
| http\_listener\_port | HTTP listener port | `number` | `80` | no |
| https\_listener\_config | List of maps of HTTPS listenr objects | <pre>object({<br>    port                   = string,<br>    certificates           = list(string),<br>    number_of_certificates = number<br>  })</pre> | `null` | no |
| idle\_timeout | Idle timeout | `number` | `60` | no |
| internal | Bool flag to indicate whether the ALB is internal or external | `bool` | `true` | no |
| ip\_address\_type | Address type for the ALB. Can be ipv4 or dual | `string` | `"ipv4"` | no |
| name | AWS ALB name | `string` | n/a | yes |
| security\_group\_ids | List of security groups to be associated with the ALB | `list(string)` | n/a | yes |
| subnet\_ids | List of subnets IDs where the ALB would be serving | `list(string)` | n/a | yes |
| timeouts | ALB creation timeouts | <pre>object({<br>    create = string,<br>    delete = string,<br>    update = string<br>  })</pre> | <pre>{<br>  "create": "10m",<br>  "delete": "10m",<br>  "update": "10m"<br>}</pre> | no |
| vpc\_id | VPC ID where the ALB needs to be provisioned | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | AWS ALB ARN |
| aws\_alb | AWS ALB attributes |
| aws\_alb\_listener\_http | AWS ALB HTTPS listener attributes |
| aws\_alb\_listener\_https | AWS ALB HTTPS listener attributes |
| default\_target\_group\_http | Default HTTP target group arn |
| default\_target\_group\_https | Default HTTPS target group arn |
| dns\_name | AWS ALB DNS name |
| http\_listner\_arn | AWS ALB HTTP listner arn |
| https\_listner\_arn | AWS ALB HTTP listner arn |
| id | AWS ALB id |
| zone\_id | AWS ALB zone id |
