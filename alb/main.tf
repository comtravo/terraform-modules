/**
 * # Comtravo's Terraform AWS ALB module
 *
 * ## Usage:
 *
 * ```hcl
 * module "website-alb" {
 *   source = "github.com/comtravo/terraform-aws-alb?ref=3.0.0"
 *
 *   environment        = terraform.workspace
 *   name               = "website"
 *   internal           = false
 *   vpc_id             = module.main_vpc.vpc_id
 *   security_group_ids = [aws_security_group.website-alb.id]
 *   subnet_ids         = module.main_vpc.public_subnets
 *   idle_timeout       = 120
 *
 *   http_listener_port = 80
 *
 *   https_listener_config = {
 *     port         = 443
 *     certificates = [
 *       data.aws_acm_certificate.comtravoDotCom.arn,
 *       data.aws_acm_certificate.webDotComtravoDotCom.arn,
 *       data.aws_acm_certificate.comtravoDotDe.arn
 *     ],
*      number_of_certificates = 3
 *   }
 * }
 * ```
 *
 */

locals {
  enable_https = var.https_listener_config != null && var.enable == true ? true : false
}

locals {
  enable_http_count  = local.enable_count
  enable_https_count = local.enable_https ? 1 : 0
}

locals {
  certificate_length = local.enable_https ? var.https_listener_config.number_of_certificates : 0
  certificates       = local.enable_https ? var.https_listener_config.certificates : []
}

locals {
  default_cert                  = local.enable_https ? element(local.certificates, 0) : ""
  additional_certificate_length = local.enable_https && local.certificate_length > 1 ? local.certificate_length - 1 : 0
}

resource "aws_alb" "alb" {
  count                      = local.enable_count
  name                       = var.name
  internal                   = var.internal
  security_groups            = var.security_group_ids
  subnets                    = var.subnet_ids
  idle_timeout               = var.idle_timeout
  ip_address_type            = var.ip_address_type
  enable_deletion_protection = var.enable_deletion_protection

  dynamic "access_logs" {
    for_each = var.access_logs

    content {
      bucket  = var.access_logs[0].bucket
      prefix  = var.access_logs[0].prefix
      enabled = var.access_logs[0].enabled
    }
  }

  tags = {
    Environment = var.environment
    Name        = var.name
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }
}

resource "aws_alb_target_group" "dummy_https" {
  count = local.enable_https_count

  name                 = "d-${var.name}-${var.https_listener_config["port"]}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10

  health_check {
    interval            = lookup(var.health_check, "interval", 30)
    path                = lookup(var.health_check, "path", "/")
    healthy_threshold   = lookup(var.health_check, "healthy_threshold", 2)
    unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold", 8)
    timeout             = lookup(var.health_check, "timeout", 5)
    matcher             = lookup(var.health_check, "matcher", 301)
    port                = "traffic-port"
  }

  tags = {
    Environment = var.environment
    Name        = var.name
  }
}

resource "aws_alb_listener" "listener_https" {
  count = local.enable_https_count

  load_balancer_arn = aws_alb.alb[0].arn
  port              = var.https_listener_config["port"]
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.default_cert

  default_action {
    target_group_arn = element(aws_alb_target_group.dummy_https.*.arn, count.index)
    type             = "forward"
  }

  depends_on = [aws_alb_target_group.dummy_https]
}

resource "aws_alb_listener_certificate" "additional_certificates" {
  count = local.additional_certificate_length

  listener_arn    = aws_alb_listener.listener_https[0].arn
  certificate_arn = element(local.certificates, count.index + 1)
}

resource "aws_alb_target_group" "dummy_http" {
  count = local.enable_http_count

  name                 = "d-${var.name}-${var.http_listener_port}"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 10

  health_check {
    interval            = lookup(var.health_check, "interval", 30)
    path                = lookup(var.health_check, "path", "/")
    healthy_threshold   = lookup(var.health_check, "healthy_threshold", 2)
    unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold", 8)
    timeout             = lookup(var.health_check, "timeout", 5)
    matcher             = lookup(var.health_check, "matcher", 301)
    port                = "traffic-port"
  }
  tags = {
    Environment = var.environment
    Name        = var.name
  }
}

resource "aws_alb_listener" "listener_http" {
  count = local.enable_http_count

  load_balancer_arn = aws_alb.alb[0].arn
  port              = var.http_listener_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = element(aws_alb_target_group.dummy_http.*.arn, count.index)
    type             = "forward"
  }

  depends_on = [aws_alb_target_group.dummy_http]
}

