locals {
  outputs = {
    public_subnets  = var.enable ? aws_subnet.public.*.id : []
    private_subnets = var.enable ? aws_subnet.private.*.id : []

    vpc_id         = var.enable ? aws_vpc.vpc[0].id : ""
    vpc_default_sg = var.enable ? aws_default_security_group.vpc-default-sg[0].id : ""

    private_zone_id   = var.enable ? aws_route53_zone.net0ps[0].zone_id : ""
    private_subdomain = var.enable ? aws_route53_zone.net0ps[0].name : ""

    public_subdomain_zone_id      = var.enable && var.subdomain != "" ? aws_route53_zone.subdomain[0].zone_id : ""
    public_subdomain              = var.enable && var.subdomain != "" ? var.subdomain : ""
    public_subdomain_name_servers = var.enable && var.subdomain != "" ? aws_route53_zone.subdomain[0].name_servers : []

    vpc_private_routing_table_id = var.enable ? aws_default_route_table.private[0].id : ""
    vpc_public_routing_table_id  = var.enable ? aws_route_table.public[0].id : ""

    dummy_dependency = null_resource.dummy_dependency
  }
}

output "public_subnets" {
  value       = local.outputs.public_subnets
  description = "Public subnets"
}

output "private_subnets" {
  value       = local.outputs.private_subnets
  description = "Private subnets"
}

output "vpc_id" {
  value       = local.outputs.vpc_id
  description = "VPC ID"
}

output "vpc_default_sg" {
  value       = local.outputs.vpc_default_sg
  description = "Default VPC security group"
}

output "net0ps_zone_id" {
  value       = local.outputs.private_zone_id
  description = "Private hosted zone ID"
}

output "private_zone_id" {
  value       = local.outputs.private_zone_id
  description = "Private hosted zone ID"
}

output "subdomain_zone_id" {
  value       = local.outputs.public_subdomain_zone_id
  description = "Subdomain hosted zone ID"
}

output "public_subdomain_zone_id" {
  value       = local.outputs.public_subdomain_zone_id
  description = "Subdomain hosted zone ID"
}

output "public_subdomain" {
  value       = local.outputs.public_subdomain
  description = "Public subdomain name"
}

output "public_subdomain_name_servers" {
  value       = local.outputs.public_subdomain_name_servers
  description = "Public subdomain name servers"
}

output "private_subdomain" {
  value       = local.outputs.private_subdomain
  description = "Private subdomain name"
}

output "vpc_private_routing_table_id" {
  value       = local.outputs.vpc_private_routing_table_id
  description = "Private routing table ID"
}

output "vpc_public_routing_table_id" {
  value       = local.outputs.vpc_public_routing_table_id
  description = "Public routing table ID"
}

output "depends_id" {
  value       = var.enable ? null_resource.dummy_dependency[0].id : ""
  description = "Dependency ID"
}
