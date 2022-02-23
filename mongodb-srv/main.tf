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

variable "txt_records" {
  description = "MongoDB replicaset TXT records"
  type        = list(string)
}

variable "members" {
  description = "Members of the mongoDB replicaset"
  type = list(object({
    hostname = string
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
