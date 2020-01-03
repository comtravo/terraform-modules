output id {
  description = "AWS ALB id"
  value       = "${element(concat(aws_alb.alb.*.id, list("")), 0)}"
}

output zone_id {
  description = "AWS ALB zone id"
  value       = "${element(concat(aws_alb.alb.*.zone_id, list("")), 0)}"
}

output arn {
  description = "AWS ALB ARN"
  value       = "${element(concat(aws_alb.alb.*.arn, list("")), 0)}"
}

output dns_name {
  description = "AWS ALB DNS name"
  value       = "${element(concat(aws_alb.alb.*.dns_name, list("")), 0)}"
}

# awesome stuff
output listener_arns {
  description = "AWS ALB listner ARNs"

  value = "${zipmap(
  compact(concat(aws_alb_listener.listener_https.*.port, aws_alb_listener.listener_http.*.port)),
  compact(concat(aws_alb_listener.listener_https.*.arn, aws_alb_listener.listener_http.*.arn))
  )}"
}

output default_target_group_http {
  description = "default HTTP target group arn"
  value       = "${element(concat(aws_alb_target_group.dummy_http.*.arn, list("")), 0)}"
}

output default_target_group_https {
  description = "default HTTPS target group arn"
  value       = "${element(concat(aws_alb_target_group.dummy_https.*.arn, list("")), 0)}"
}
