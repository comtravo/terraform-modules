variable "name" {
  type = string
}

module "bucket" {
  source = "../../"

  enable = false
  name   = var.name
}

output "bucket" {
  value = module.bucket.bucket
}
