variable "name" {
  type = string
}

module "bucket" {
  source = "../../"

  enable = false
  name   = var.name
}

output "output" {
  value = module.bucket.output
}
