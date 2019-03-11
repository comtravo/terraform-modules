variable vpc_name {}
variable cidr {}
variable environment {}
variable enable {}
variable replication_factor {}

variable nat_az_number {
  default = 0
}

variable subdomain {
  default = ""
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

variable azs {
  type = "list"
}
