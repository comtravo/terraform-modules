locals {
  enable_https = var.https_listener_config && var.enable ? true : false
  enable_http  = var.enable
}

locals {
  certificate_length = local.enable_https ? length(lookup(var.https_listener_config, "certificates")) : 0
  certificates       = local.enable_https ? lookup(var.https_listener_config, "certificates") : 0
}

locals {
  default_cert                  = local.enable_https ? element(local.certificates, 0) : ""
  additional_certificate_length = var.enable_https ? local.certificate_length - 1 : 0
}

resource "aws_alb" "alb" {
  count                      = var.enable
  name                       = var.name
  internal                   = var.internal
  security_groups            = var.security_group_ids
  subnets                    = var.subnet_ids
  idle_timeout               = var.idle_timeout
  ip_address_type            = var.ip_address_type
  enable_deletion_protection = true

  tags = {
    Environment = var.environment
    Name        = var.name
  }

  timeouts = var.timeouts
}

resource "aws_alb_target_group" "dummy_https" {
  count = local.enable_https

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
  count = local.enable_https

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
  count = local.enable_http

  name                 = "d-${var.name}-${var.http_listeners[count.index]}"
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
  count = local.enable_http

  load_balancer_arn = aws_alb.alb[0].arn
  port              = element(var.http_listeners, count.index)
  protocol          = "HTTP"

  default_action {
    target_group_arn = element(aws_alb_target_group.dummy_http.*.arn, count.index)
    type             = "forward"
  }

  depends_on = [aws_alb_target_group.dummy_http]
}

