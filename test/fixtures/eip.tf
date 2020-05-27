variable "external_eip_count" {
  type    = number
  default = 5
}

resource "aws_eip" "external" {
  count = var.external_eip_count
  vpc   = true
}

output "external_elastic_ips" {
  value = aws_eip.external.*.id
}
