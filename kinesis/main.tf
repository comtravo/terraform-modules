variable "enable" {
  type        = bool
  description = "Enable module"
  default     = true
}

variable "configuration" {
  type = object({
    name                      = string
    shard_count               = number
    retention_period          = number
    shard_level_metrics       = list(string)
    enforce_consumer_deletion = bool
    encryption_type           = string
    kms_key_id                = string
    tags                      = map(string)
  })
  description = "Kinesis stream configuration: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream"
}

resource "aws_kinesis_stream" "this" {
  count = var.enable ? 1 : 0

  name                      = var.configuration.name
  shard_count               = lookup(var.configuration, "shard_count", null)
  retention_period          = lookup(var.configuration, "retention_period", null)
  shard_level_metrics       = lookup(var.configuration, "shard_level_metrics", null)
  enforce_consumer_deletion = lookup(var.configuration, "enforce_consumer_deletion", null)
  encryption_type           = lookup(var.configuration, "encryption_type", null)
  kms_key_id                = lookup(var.configuration, "kms_key_id", null)
  tags                      = lookup(var.configuration, "tags", null)
}

output "output" {
  value       = aws_kinesis_stream.this
  description = "AWS Kinesis attributes"
}
