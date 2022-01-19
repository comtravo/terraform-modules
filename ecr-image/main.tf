variable "registry_id" {
  description = "AWS ECR registry ID"
  default     = "940226765273"
  type        = string
}

variable "repository_name" {
  description = "AWS ECR repository name"
  type        = string
}

variable "image_tag" {
  description = "AWS ECR image tag"
  type        = string
}

data "aws_ecr_image" "service_image" {
  registry_id     = var.registry_id
  repository_name = var.repository_name
  image_tag       = var.image_tag
}

output "repository_url" {
  value       = data.aws_ecr_repository.service.repository_url
  description = "ECR url"
}

output "image_digest" {
  value       = data.aws_ecr_image.service_image.image_digest
  description = "Docker image digest"
}

output "image" {
  value       = "${data.aws_ecr_repository.service.repository_url}@${data.aws_ecr_image.service_image.image_digest}"
  description = "Docker image"
}

