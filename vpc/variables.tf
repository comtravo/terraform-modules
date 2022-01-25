variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr" {
  description = "CIDR of the VPC"
  type        = string
}

variable "tags" {
  description = "Map of tags to tag all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_tags" {
  description = "Map of tags to vpc"
  type        = map(string)
  default     = {}
}

variable "enable" {
  description = "Enable or disable creation of resources"
  default     = true
  type        = bool
}

variable "availability_zones" {
  description = "List of avaliability zones"
  type        = list(string)
}

variable "subdomain" {
  description = "Public subdomain name"
  default     = ""
  type        = string
}

variable "nat_gateway" {
  description = "NAT gateway creation behavior. If `one_nat_per_availability_zone` A NAT gateway is created per availability zone."
  type = object({
    behavior = string
  })
  default = {
    behavior = "one_nat_per_vpc"
  }
}

# Inter module dependency hack
# https://github.com/hashicorp/terraform/issues/1178
variable "depends_id" {
  type        = string
  default     = ""
  description = "Inter module dependency id"
}

variable "enable_dns_support" {
  default     = true
  type        = bool
  description = "Enable DNS support in VPC"
}

variable "enable_dns_hostnames" {
  default     = true
  type        = bool
  description = "Enable DNS hostmanes in VPC"
}

variable "assign_generated_ipv6_cidr_block" {
  default     = true
  type        = bool
  description = "Create ipv6 CIDR block"
}

variable "private_subnets" {
  description = "Private subnet CIDR ipv4 config"
  type = object({
    number_of_subnets = number
    newbits           = number
    netnum_offset     = number
    tags              = map(string)
  })
  default = {
    number_of_subnets = 3
    newbits           = 8
    netnum_offset     = 0
    tags              = {}
  }
}

variable "public_subnets" {
  description = "Public subnet CIDR ipv4 config"
  type = object({
    number_of_subnets = number
    newbits           = number
    netnum_offset     = number
    tags              = map(string)
  })
  default = {
    number_of_subnets = 3
    newbits           = 8
    netnum_offset     = 100
    tags              = {}
  }
}

variable "external_elastic_ips" {
  description = "List of elastic IPs to use instead of creating within the module"
  type        = list(string)
  default     = []
}

