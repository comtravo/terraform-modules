variable "enable" {
  default     = true
  description = "Enable or disable the module"
  type        = bool
}

variable "name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "acl" {
  type        = string
  description = "Bucket ACL"
  default     = "private"
}

variable "force_destroy" {
  type        = bool
  description = "Force destroy the bucket"
  default     = false
}

variable "versioning" {
  type        = bool
  description = "Enable versioning in the S3 bucket"
  default     = false
}
variable "tags" {
  default     = null
  description = "Tags to apply to the bucket"
  type        = map(string)
}

variable "block_public_access" {
  type        = bool
  description = "Block public access to the bucket"
  default     = true
}

variable "lifecycle_rules" {
  description = "Lifecycle rule to apply to the bucket"
  type = list(object({
    id                                     = string
    prefix                                 = string
    abort_incomplete_multipart_upload_days = number
    expiration = object({
      days = number
    })
    transition = object({
      days          = number
      storage_class = string
    })
  }))
  default = []
}


resource "aws_s3_bucket" "this" {

  count = var.enable ? 1 : 0

  bucket        = var.name
  acl           = var.acl
  force_destroy = var.force_destroy

  versioning {
    enabled = var.versioning
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      id                                     = lifecycle_rule.value.id
      prefix                                 = lifecycle_rule.value.prefix
      enabled                                = true
      abort_incomplete_multipart_upload_days = lifecycle_rule.value.abort_incomplete_multipart_upload_days

      dynamic "expiration" {
        for_each = lifecycle_rule.value.expiration != null ? [lifecycle_rule.value.expiration] : []

        content {
          days = expiration.value.days
        }
      }

      dynamic "transition" {
        for_each = lifecycle_rule.value.transition != null ? [lifecycle_rule.value.transition] : []

        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }


    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      replication_configuration
    ]
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  count = var.enable ? 1 : 0

  bucket = aws_s3_bucket.this[0].bucket

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = var.enable ? 1 : 0

  bucket                  = aws_s3_bucket.this[0].bucket
  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  restrict_public_buckets = var.block_public_access
  ignore_public_acls      = var.block_public_access
}

output "bucket" {
  description = "S3 bucket output"
  value       = try(aws_s3_bucket.this[0], {})
}

output "aws_s3_bucket_public_access_block" {
  description = "S3 bucket output"
  value       = try(aws_s3_bucket_public_access_block.this[0], {})
}

output "aws_s3_bucket_ownership_controls" {
  description = "S3 bucket output"
  value       = try(aws_s3_bucket_ownership_controls.this[0], {})
}
