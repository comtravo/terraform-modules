variable "name" {
  type = string
}

module "bucket" {
  source = "../../"

  name = var.name
}

output "output" {
  value = module.bucket.output
}
