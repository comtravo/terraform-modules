output "aws_apigatewayv2_api" {
  description = "aws_apigatewayv2_api outputs"
  value       = aws_apigatewayv2_api.this
}

output "aws_apigatewayv2_deployment" {
  description = "aws_apigatewayv2_deployment outputs"
  value       = aws_apigatewayv2_deployment.this
}

output "aws_apigatewayv2_stage" {
  description = "aws_apigatewayv2_stage outputs"
  value       = aws_apigatewayv2_stage.this
}

output "aws_apigatewayv2_domain_name" {
  description = "aws_apigatewayv2_domain_name outputs"
  value       = aws_apigatewayv2_domain_name.this
}
output "aws_route53_record" {
  description = "aws_route53_record outputs"
  value       = aws_route53_record.this
}

output "aws_cloudwatch_log_group" {
  description = "aws_cloudwatch_log_group outputs"
  value       = aws_cloudwatch_log_group.this
}
output "aws_apigatewayv2_api_mapping" {
  description = "aws_apigatewayv2_api_mapping outputs"
  value       = aws_apigatewayv2_api_mapping.this
}
