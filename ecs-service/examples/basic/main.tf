variable "name" {
  type = string
}

module "ecs_service" {
  source = "../../"

  name = var.name
}

output "target_group" {
  value = module.ecs_service.target_group
}
