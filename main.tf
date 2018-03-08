locals {
  enable_https       = "${length(keys(var.https_listeners)) * var.enable > 0 ? 1 : 0}"
  certificate_length = "${length(split(",", lookup(var.https_listeners, "certificates", "")))}"
  certificates       = ["${split(",", lookup(var.https_listeners, "certificates", ""))}"]
  enable_http        = "${length(var.http_listeners) * var.enable}"
}

locals {
  default_cert                  = "${local.enable_https ? element(local.certificates, 0) : "foo"}"
  additional_certificate_length = "${local.certificate_length - 1}"
}

resource "aws_alb" "alb" {
  count           = "${var.enable}"
  name            = "${var.name}"
  internal        = "${var.internal}"
  security_groups = ["${var.security_group_ids}"]
  subnets         = ["${var.subnet_ids}"]

  # Terraform 10+
  # load_balancer_type          = "${var.load_balancer_type}"
  idle_timeout = "${var.idle_timeout}"

  ip_address_type = "${var.ip_address_type}"

  enable_deletion_protection = false

  tags {
    Environment = "${var.environment}"
    Name        = "${var.name}"
  }

  timeouts = "${var.timeouts}"
}

resource "aws_alb_target_group" "dummy_https" {
  count = "${local.enable_https}"

  name     = "d-${var.name}-${lookup(var.https_listeners, "port")}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_listener" "listener_https" {
  count = "${local.enable_https}"

  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${lookup(var.https_listeners, "port")}"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${local.default_cert}"

  default_action {
    target_group_arn = "${element(aws_alb_target_group.dummy_https.*.arn, count.index)}"
    type             = "forward"
  }

  depends_on = ["aws_alb_target_group.dummy_https"]
}

resource "aws_alb_listener_certificate" "additional_certificates" {
  count = "${local.enable_https * local.additional_certificate_length >= 1 ? local.additional_certificate_length : 0}"

  listener_arn    = "${aws_alb_listener.listener_https.arn}"
  certificate_arn = "${element(local.certificates, count.index+1)}"
}

resource "aws_alb_target_group" "dummy_http" {
  count = "${local.enable_http}"

  name     = "d-${var.name}-${var.http_listeners[count.index]}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_alb_listener" "listener_http" {
  count = "${local.enable_http}"

  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "${element(var.http_listeners, count.index)}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${element(aws_alb_target_group.dummy_http.*.arn, count.index)}"
    type             = "forward"
  }

  depends_on = ["aws_alb_target_group.dummy_http"]
}
