variable "enable" {
  type        = bool
  description = "Enable module"
  default     = true
}
variable "name" {
  type        = string
  description = "Name of the AWS Kinesis stream"
}

variable "shard_count" {
  type        = number
  description = "AWS Kinesis stream shard count"
  default     = 1
}
variable "retention_period" {
  type        = number
  description = "AWS Kinesis stream retention period"
  default     = 24
}

variable "shard_level_metrics" {
  type        = list(string)
  description = "AWS Kinesis stream shard level metrics"
  default     = []
}

variable "enforce_consumer_deletion" {
  type        = bool
  description = "AWS Kinesis stream enforce deleting consumers before deleting the stream"
  default     = true
}

variable "encryption_type" {
  type        = string
  description = "AWS Kinesis stream encryption type"
  default     = "KMS"
}

variable "kms_key_id" {
  type        = string
  description = "AWS Kinesis stream KMS key ID"
  default     = "alias/aws/kinesis"
}

variable "tags" {
  type        = map(string)
  description = "AWS Kinesis stream tags"
  default     = {}
}

resource "aws_kinesis_stream" "this" {
  count = var.enable ? 1 : 0

  name                      = var.name
  shard_count               = var.shard_count
  retention_period          = var.retention_period
  shard_level_metrics       = var.shard_level_metrics
  enforce_consumer_deletion = var.enforce_consumer_deletion
  encryption_type           = var.encryption_type
  kms_key_id                = var.kms_key_id
  tags                      = var.tags
}

output "output" {
  value       = aws_kinesis_stream.this[0]
  description = "AWS Kinesis attributes"
}
