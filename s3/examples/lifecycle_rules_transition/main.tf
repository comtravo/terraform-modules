variable "name" {
  type = string
}

module "bucket" {
  source = "../../"

  name = var.name
  tags = {
    "tag1" = "value1"
  }

  force_destroy = true
  lifecycle_rules = [{
    id                                     = "rule1"
    prefix                                 = "prefix1"
    abort_incomplete_multipart_upload_days = 7
    expiration                             = null
    transition = {
      days          = 7
      storage_class = "GLACIER"
    }
  }]
}

output "bucket" {
  value = module.bucket.bucket
}

output "aws_s3_bucket_public_access_block" {
  value = module.bucket.aws_s3_bucket_public_access_block
}

output "aws_s3_bucket_ownership_controls" {
  value = module.bucket.aws_s3_bucket_ownership_controls
}
