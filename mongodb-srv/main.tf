terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

variable "zone_id" {
  description = "AWS R53 Zone ID"
  type        = string
}

variable "hostname" {
  description = "MongoDB replicaset hostname"
  type        = string
}

variable "domain" {
  description = "Domain name for members"
  type        = string
}

variable "txt_records" {
  description = "MongoDB replicaset TXT records"
  type        = list(string)
}

variable "members" {
  description = "Members of the MongoDB replicaset"
  type = list(object({
    host     = string
    port     = string
    priority = number
    weight   = number
  }))
}

resource "aws_route53_record" "txt" {
  zone_id = var.zone_id
  name    = var.hostname
  type    = "TXT"
  ttl     = "60"

  records = var.txt_records
}

locals {
  members = { for member in var.members : "${member.host}:${member.port}" => member }
}

resource "random_pet" "member" {
  for_each = local.members

  keepers = {
    member = each.key
  }
}

resource "aws_route53_record" "member" {
  for_each = local.members

  zone_id = var.zone_id
  name    = "${random_pet.member[each.key].id}.${var.domain}"
  type    = "CNAME"
  ttl     = "60"

  records = [each.value.private_dns]

}

resource "aws_route53_record" "srv" {
  zone_id = var.zone_id
  name    = "_mongodb._tcp.${var.hostname}"
  type    = "SRV"
  ttl     = "60"

  records = [for member in var.members : "${member.priority} ${member.weight} ${member.port} ${member.host}"]
}

output "srv" {
  value       = aws_route53_record.srv
  description = "SRV record"
}

output "txt" {
  value       = aws_route53_record.txt
  description = "TXT record"
}

output "members" {
  value       = aws_route53_record.member
  description = "MongoDB members"
}
