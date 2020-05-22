output "id" {
  description = "AWS ALB id"
  value       = aws_alb.alb[0].id
}

output "zone_id" {
  description = "AWS ALB zone id"
  value       = aws_alb.alb[0].zone_id
}

output "arn" {
  description = "AWS ALB ARN"
  value       = aws_alb.alb[0].arn
}

output "dns_name" {
  description = "AWS ALB DNS name"
  value       = aws_alb.alb[0].dns_name
}

# awesome stuff
output "listener_arns" {
  description = "AWS ALB listner ARNs"

  value = zipmap(
    compact(
      concat(
        aws_alb_listener.listener_https.*.port,
        aws_alb_listener.listener_http.*.port,
      ),
    ),
    compact(
      concat(
        aws_alb_listener.listener_https.*.arn,
        aws_alb_listener.listener_http.*.arn,
      ),
    ),
  )
}

output "default_target_group_http" {
  description = "default HTTP target group arn"
  value       = aws_alb_target_group.dummy_http[0].arn
}

output "default_target_group_https" {
  description = "default HTTPS target group arn"
  value       = aws_alb_target_group.dummy_https[0].arn
}

