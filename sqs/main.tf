variable "name" {
  type        = string
  description = "SQS Name"
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "SQS Visibility Timeout in Seconds"
}

variable "sns_subscriptions_arns" {
  type        = list(string)
  default     = []
  description = "SNS Topic ARNs to subscribe to"
}

resource "aws_sqs_queue" "this" {
  name                       = var.name
  visibility_timeout_seconds = var.visibility_timeout_seconds

  redrive_policy = <<EOF
{
  "deadLetterTargetArn": "${aws_sqs_queue.this-dlq.arn}",
  "maxReceiveCount": 12
}
EOF
}

resource "aws_sqs_queue" "this-dlq" {
  name = "${var.name}-dlq"
}

output "queue" {
  value       = aws_sqs_queue.this
  description = "SQS attributes"
}

output "queue-dlq" {
  value       = aws_sqs_queue.this-dlq
  description = "SQS DLQ attributes"
}

data "aws_iam_policy_document" "SendMessage" {
  count = length(var.sns_subscriptions_arns) > 0 ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["SQS:SendMessage"]
    resources = [
      aws_sqs_queue.this.arn
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "ForAnyValue:ArnLike"
      variable = "aws:SourceArn"
      values   = var.sns_subscriptions_arns
    }
  }
}

resource "aws_sqs_queue_policy" "SendMessage" {
  count     = length(var.sns_subscriptions_arns) > 0 ? 1 : 0
  queue_url = aws_sqs_queue.this.id
  policy    = data.aws_iam_policy_document.SendMessage[0].json
}

resource "aws_sns_topic_subscription" "to-sqs" {
  for_each  = toset(var.sns_subscriptions_arns)
  protocol  = "sqs"
  topic_arn = each.key
  endpoint  = aws_sqs_queue.this.arn
}
