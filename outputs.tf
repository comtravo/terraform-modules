output "id" {
  description = "AWS ALB id"
  value       = element(concat(aws_alb.alb.*.id, [""]), 0)
}

output "zone_id" {
  description = "AWS ALB zone id"
  value       = element(concat(aws_alb.alb.*.zone_id, [""]), 0)
}

output "arn" {
  description = "AWS ALB ARN"
  value       = element(concat(aws_alb.alb.*.arn, [""]), 0)
}

output "dns_name" {
  description = "AWS ALB DNS name"
  value       = element(concat(aws_alb.alb.*.dns_name, [""]), 0)
}

output "http_listner_arn" {
  description = "AWS ALB HTTP listner arn"
  value       = element(concat(aws_alb_listener.listener_http.*.arn, [""]), 0)
}

output "https_listner_arn" {
  description = "AWS ALB HTTP listner arn"
  value       = element(concat(aws_alb_listener.listener_https.*.arn, [""]), 0)
}

output "default_target_group_http" {
  description = "Default HTTP target group arn"
  value       = element(concat(aws_alb_target_group.dummy_http.*.arn, [""]), 0)
}

output "default_target_group_https" {
  description = "Default HTTPS target group arn"
  value       = element(concat(aws_alb_target_group.dummy_https.*.arn, [""]), 0)
}

