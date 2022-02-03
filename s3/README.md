## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | Bucket ACL | `string` | `"private"` | no |
| <a name="input_block_public_access"></a> [block\_public\_access](#input\_block\_public\_access) | Block public access to the bucket | `bool` | `true` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable or disable the module | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Force destroy the bucket | `bool` | `false` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | Lifecycle rule to apply to the bucket | <pre>list(object({<br>    id                                     = string<br>    prefix                                 = string<br>    abort_incomplete_multipart_upload_days = number<br>    expiration = object({<br>      days = number<br>    })<br>    transition = object({<br>      days          = number<br>      storage_class = string<br>    })<br>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the S3 bucket | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the bucket | `map(string)` | `null` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Enable versioning in the S3 bucket | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_s3_bucket_ownership_controls"></a> [aws\_s3\_bucket\_ownership\_controls](#output\_aws\_s3\_bucket\_ownership\_controls) | S3 bucket output |
| <a name="output_aws_s3_bucket_public_access_block"></a> [aws\_s3\_bucket\_public\_access\_block](#output\_aws\_s3\_bucket\_public\_access\_block) | S3 bucket output |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | S3 bucket output |
