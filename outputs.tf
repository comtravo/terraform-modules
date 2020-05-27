locals {
  outputs = {
    public_subnets                = var.enable ? aws_subnet.public.*.id : []
    private_subnets               = var.enable ? aws_subnet.private.*.id : []
    vpc_id                        = var.enable ? aws_vpc.vpc[0].id : ""
    vpc_default_sg                = var.enable ? aws_default_security_group.vpc-default-sg[0].id : ""
    net0ps_zone_id                = var.enable ? aws_route53_zone.net0ps[0].zone_id : ""
    subdomain_zone_id             = var.enable && var.subdomain != "" ? aws_route53_zone.subdomain[0].zone_id : ""
    vpc_private_routing_table_ids = var.enable ? aws_route_table.private.*.id : []
    vpc_public_routing_table_id   = var.enable ? aws_route_table.public[0].id : ""
    private_subdomain             = var.enable ? aws_route53_zone.net0ps[0].name : ""
    depends_id                    = var.enable ? null_resource.dummy_dependency[0].id : ""
    nat_gateway_ids               = var.enable ? aws_nat_gateway.nat.*.id : []
    elastic_ips                   = var.enable && length(var.external_elastic_ips) > 0 ? var.external_elastic_ips : var.enable ? aws_eip.nat.*.id : []
  }
}

output "elastic_ips" {
  value       = local.outputs.elastic_ips
  description = "List of elastic ips"
}

output "public_subnets" {
  value       = local.outputs.public_subnets
  description = "List of public subnets"
}

output "private_subnets" {
  value       = local.outputs.private_subnets
  description = "List of private subnets"
}

output "vpc_id" {
  value       = local.outputs.vpc_id
  description = "VPC id"
}

output "vpc_default_sg" {
  value       = local.outputs.vpc_default_sg
  description = "Default security group"
}

output "net0ps_zone_id" {
  value       = local.outputs.net0ps_zone_id
  description = "Private hosted zone id"
}

output "private_zone_id" {
  value       = local.outputs.net0ps_zone_id
  description = "Private hosted zone name"
}

output "public_subdomain" {
  value       = var.subdomain
  description = "Public hosted zone name"
}

output "private_subdomain" {
  value       = local.outputs.private_subdomain
  description = "Private hosted zone name"
}

output "subdomain_zone_id" {
  value       = local.outputs.subdomain_zone_id
  description = "Public hosted zone id"
}

output "public_subdomain_zone_id" {
  value       = local.outputs.subdomain_zone_id
  description = "Public hosted zone id"
}

output "nat_gateway_ids" {
  value       = local.outputs.nat_gateway_ids
  description = "NAT gateway ids"
}

output "vpc_private_routing_table_ids" {
  value       = local.outputs.vpc_private_routing_table_ids
  description = "Private routing table id"
}

output "vpc_public_routing_table_id" {
  value       = local.outputs.vpc_public_routing_table_id
  description = "Public routing table id"
}

output "depends_id" {
  value       = local.outputs.depends_id
  description = "Dependency id"
}

