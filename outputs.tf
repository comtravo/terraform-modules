output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "vpc_id" {
  value = "${element(concat(aws_vpc.vpc.*.id, list("")), 0)}"
}

output "vpc_default_sg" {
  value = "${element(concat(aws_default_security_group.vpc-default-sg.*.id, list("")), 0)}"
}

output "net0ps_zone_id" {
  value = "${element(concat(aws_route53_zone.net0ps.*.zone_id, list("")), 0)}"
}

output "private_zone_id" {
  value = "${element(concat(aws_route53_zone.net0ps.*.zone_id, list("")), 0)}"
}

output "subdomain_zone_id" {
  value = "${element(concat(aws_route53_zone.subdomain.*.zone_id, list("")), 0)}"
}

output "public_subdomain_zone_id" {
  value = "${element(concat(aws_route53_zone.subdomain.*.zone_id, list("")), 0)}"
}

output "public_subdomain" {
  value = "${var.subdomain}"
}

output "private_subdomain" {
  value = "${element(concat(aws_route53_zone.net0ps.*.name, list("")), 0)}"
}

output "vpc_private_routing_table_id" {
  value = "${element(concat(aws_default_route_table.private.*.id, list("")), 0)}"
}

output "vpc_public_routing_table_id" {
  value = "${element(concat(aws_route_table.public.*.id, list("")), 0)}"
}

output "depends_id" {
  value = "${null_resource.dummy_dependency.id}"
}
