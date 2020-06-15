output "id" {
  description = "AWS ALB id"
  value       = var.enable ? aws_alb.alb[0].id : ""
}

output "zone_id" {
  description = "AWS ALB zone id"
  value       = var.enable ? aws_alb.alb[0].zone_id : ""
}

output "arn" {
  description = "AWS ALB ARN"
  value       = var.enable ? aws_alb.alb[0].arn : ""
}

output "dns_name" {
  description = "AWS ALB DNS name"
  value       = var.enable ? aws_alb.alb[0].dns_name : ""
}

output "http_listner_arn" {
  description = "AWS ALB HTTP listner arn"
  value       = var.enable ? aws_alb_listener.listener_http[0].arn : ""
}

output "https_listner_arn" {
  description = "AWS ALB HTTP listner arn"
  value       = local.enable_https ? aws_alb_listener.listener_https[0].arn : ""
}

output "default_target_group_http" {
  description = "Default HTTP target group arn"
  value       = var.enable ? aws_alb_target_group.dummy_http[0].arn : ""
}

output "default_target_group_https" {
  description = "Default HTTPS target group arn"
  value       = local.enable_https ? aws_alb_target_group.dummy_https[0].arn : ""
}

