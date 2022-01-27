## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acl | Bucket ACL | `string` | `"private"` | no |
| block\_public\_access | Block public access to the bucket | `bool` | `true` | no |
| enable | Enable or disable the module | `bool` | `true` | no |
| force\_destroy | Force destroy the bucket | `bool` | `false` | no |
| lifecycle\_rules | Lifecycle rule to apply to the bucket | <pre>list(object({<br>    id                                     = string<br>    prefix                                 = string<br>    abort_incomplete_multipart_upload_days = number<br>    expiration = object({<br>      days = number<br>    })<br>    transition = object({<br>      days          = number<br>      storage_class = string<br>    })<br>  }))</pre> | `[]` | no |
| name | Name of the S3 bucket | `string` | n/a | yes |
| tags | Tags to apply to the bucket | `map(string)` | `null` | no |
| versioning | Enable versioning in the S3 bucket | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_s3\_bucket\_ownership\_controls | S3 bucket output |
| aws\_s3\_bucket\_public\_access\_block | S3 bucket output |
| bucket | S3 bucket output |
