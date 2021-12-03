variable "name" {
  type = string
}

module "bucket" {
  source = "../../"

  name       = var.name
  versioning = true
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
