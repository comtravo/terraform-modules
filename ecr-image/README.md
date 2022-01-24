## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| image\_tag | AWS ECR image tag | `string` | n/a | yes |
| registry\_id | AWS ECR registry ID | `string` | `"940226765273"` | no |
| repository\_name | AWS ECR repository name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| image | Docker image |
| image\_digest | Docker image digest |
| repository\_url | ECR url |
