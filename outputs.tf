output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_default_sg" {
  value = "${aws_default_security_group.vpc-default-sg.id}"
}

output "net0ps_zone_id" {
  value = "${aws_route53_zone.net0ps.zone_id}"
}

output "private_zone_id" {
  value = "${aws_route53_zone.net0ps.zone_id}"
}

output "subdomain_zone_id" {
  value = "${aws_route53_zone.subdomain.zone_id}"
}

output "public_subdomain_zone_id" {
  value = "${aws_route53_zone.subdomain.zone_id}"
}

output "public_subdomain" {
  value = "${var.subdomain}"
}

output "private_subdomain" {
  value = "${aws_route53_zone.net0ps.name}"
}

output "vpc_private_routing_table_id" {
  value = "${aws_default_route_table.private.id}"
}

output "vpc_public_routing_table_id" {
  value = "${aws_route_table.public.id}"
}

output "depends_id" {
  value = "${null_resource.dummy_dependency.id}"
}
