variable "name" {
  type = string
}

module "ecs_service" {
  source = "../../"

  name = var.name
}

output "target_groups" {
  value = module.ecs_service.target_groups
}
