resource "aws_route53_record" "wildcard" {
  zone_id = "${var.dns_zone_id}"
  name = "*.${var.env}-hipache.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.router.dns_name}"]
}

resource "aws_route53_record" "api-external" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-api.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.api-ext.dns_name}"]
}

resource "aws_route53_record" "api-internal" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-api-int.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.api-int.dns_name}"]
}

resource "aws_route53_record" "gandalf" {
  zone_id = "${var.dns_zone_id}"
  name = "${var.env}-gandalf.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.gandalf.public_ip}"]
}

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
