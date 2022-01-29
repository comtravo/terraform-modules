## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_image.service_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_image) | data source |
| [aws_ecr_repository.service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | AWS ECR image tag | `string` | n/a | yes |
| <a name="input_registry_id"></a> [registry\_id](#input\_registry\_id) | AWS ECR registry ID | `string` | `"940226765273"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | AWS ECR repository name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_image"></a> [image](#output\_image) | Docker image |
| <a name="output_image_digest"></a> [image\_digest](#output\_image\_digest) | Docker image digest |
| <a name="output_repository_url"></a> [repository\_url](#output\_repository\_url) | ECR url |
