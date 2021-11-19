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

variable "tags" {
  default     = {}
  description = "Tags to apply to the bucket"
  type        = map(any)
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
    tags                                   = map(string)
    abort_incomplete_multipart_upload_days = number
    expiration = object({
      days = number
    })
  }))
  default = []
}


resource "aws_s3_bucket" "this" {

  count = var.enable ? 1 : 0

  bucket        = var.name
  acl           = var.acl
  force_destroy = var.force_destroy

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
      id                                     = each.value.id
      prefix                                 = each.value.prefix
      tags                                   = var.tags
      enabled                                = true
      abort_incomplete_multipart_upload_days = each.value.abort_incomplete_multipart_upload_days
      expiration {
        days = each.value.expiration.days
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

# resource "aws_s3_bucket_ownership_controls" "this" {
#   count = var.enable ? 1 : 0

#   bucket = aws_s3_bucket.this[0].bucket

#   rule {
#     object_ownership = "BucketOwnerPreferred"
#   }
# }

# resource "aws_s3_bucket_public_access_block" "this" {
#   count = var.enable ? 1 : 0

#   bucket                  = aws_s3_bucket.this[0].bucket
#   block_public_acls       = var.block_public_access
#   block_public_policy     = var.block_public_access
#   restrict_public_buckets = var.block_public_access
#   ignore_public_acls      = var.block_public_access
# }

output "output" {
  description = "S3 bucket output"
  value       = try(aws_s3_bucket.this[0], {})
}
