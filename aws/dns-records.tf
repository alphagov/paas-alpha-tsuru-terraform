
resource "aws_route53_record" "nat" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-nat.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.nat.public_ip}"]
}

resource "aws_route53_record" "docker-registry" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-docker-registry.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.docker-registry.private_ip}"]
}


