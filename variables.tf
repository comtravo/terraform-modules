variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "cidr" {
  type        = string
  description = "CIDR"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "enable" {
  type        = bool
  description = "Enable or Disable the module"
}

variable "replication_factor" {
  type        = number
  description = "Number of subnets, routing tables, NAT gateways"
}

variable "nat_az_number" {
  default     = 0
  type        = number
  description = "Subnet number to deploy NAT gateway in"
}

variable "subdomain" {
  default     = ""
  type        = string
  description = "Subdomain name"
}

# Inter module dependency hack
# https://github.com/hashicorp/terraform/issues/1178
variable "depends_id" {
  default     = ""
  type        = string
  description = "For inter module dependencies"
}

variable "enable_dns_support" {
  default     = true
  type        = bool
  description = "Enable DNS support"
}

variable "enable_dns_hostnames" {
  default     = true
  type        = bool
  description = "Enable DNS hostnames"
}

variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

locals {
  enable_count = var.enable ? 1 : 0
}

locals {
  replication_count = local.enable_count * var.replication_factor
}
