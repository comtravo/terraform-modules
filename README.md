# Terraform AWS module for AWS ALB

## Introduction
This module create an ALB and all the resources related to it.

## Usage

```hcl
module "my-company-external-alb" {
  source = "github.com/comtravo/terraform-aws-alb"

  environment        = "${terraform.workspace}"
  name               = "my-company-external-${var.ct_environment_name}"
  internal           = false
  vpc_id             = "${module.main_vpc.vpc_id}"
  security_group_ids = ["${aws_security_group.my-company-external-alb.id}"]
  subnet_ids         = "${module.main_vpc.public_subnets}"

  http_listeners = ["80"]

  https_listeners = {
    port        = 443
    certificates = "${join(",", list(data.aws_acm_certificate.wildcardDotSubdomainDotComtravoDotCom.arn, data.aws_acm_certificate.wildcardDotComtravoDotCom.arn))}"
  }
}
```

## TODO
- [ ] Support multiple HTTPS listeners
- [ ] Create subnet per ALB so that AWS has no problems to scale the ALB
- [ ] Proper Versioning pipeline


## Authors

Module managed by [Comtravo](https://github.com/comtravo).

License
-------

MIT Licensed. See LICENSE for full details.
