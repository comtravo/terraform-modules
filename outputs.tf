locals {
  outputs = {
    public_subnets  = aws_subnet.public.*.id
    private_subnets = aws_subnet.private.*.id

    vpc_id         = element(concat(aws_vpc.vpc.*.id, [""]), 0)
    vpc_default_sg = element(concat(aws_default_security_group.vpc-default-sg.*.id, [""]), 0)

    private_zone_id   = element(concat(aws_route53_zone.net0ps.*.zone_id, [""]), 0)
    private_subdomain = element(concat(aws_route53_zone.net0ps.*.name, [""]), 0)

    public_subdomain_zone_id      = element(concat(aws_route53_zone.subdomain.*.zone_id, [""]), 0)
    public_subdomain              = var.subdomain
    public_subdomain_name_servers = var.enable && var.subdomain != "" ? flatten(aws_route53_zone.subdomain.*.name_servers) : []

    vpc_private_routing_table_id = element(concat(aws_default_route_table.private.*.id, [""]), 0)
    vpc_public_routing_table_id  = element(concat(aws_route_table.public.*.id, [""]), 0)

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
