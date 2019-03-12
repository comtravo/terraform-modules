variable vpc_name {
  description = "Name of the VPC"
}

variable cidr {
  description = "CIDR of the VPC"
}

variable tags {
  description = "Map of tags to tag resources"
  default     = {}
}

variable enable {
  description = "Enable or disable creation of resources"
  default     = 1
}

variable availability_zones {
  description = "Avaliability zones"
  default     = []
}

variable subdomain {
  description = "Create public sub domain"
  default     = ""
}

variable nat_gateway {
  description = "NAT gateway creation behavior"

  default {
    behavior = ""
  }
}

# Inter module dependency hack
# https://github.com/hashicorp/terraform/issues/1178
variable depends_id {}

variable enable_dns_support {
  default = true
}

variable enable_dns_hostnames {
  default = true
}

variable assign_generated_ipv6_cidr_block {
  default = true
}

variable private_subnets {
  description = "Private subnet CIDR config"

  default = {
    number_of_subnets = 3
    newbits           = 8
    netnum_offset     = 0
  }
}

variable public_subnets {
  description = "Public subnet CIDR config"

  default = {
    number_of_subnets = 3
    newbits           = 8
    netnum_offset     = 100
  }
}

variable external_elastic_ips {
  description = "List of elastic IPs to use instead of creating within the module"
  type        = "list"
  default     = []
}
