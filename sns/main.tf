variable "name" {
  type        = string
  description = "SNS topic name"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "this" {
  name = var.name
}

output "arn" {
  description = "SNS topic ARN"
  value       = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${var.name}" # Generated so that plans succeed when this output is used in for example count or for_each
}

output "aws_sns_topic" {
  value       = aws_sns_topic.this
  description = "SNS topic attributes"
}
