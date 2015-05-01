/* Router CNAME record */
resource "aws_route53_record" "router" {
  zone_id = "${var.dns_zone_id_external}"
  name = "hipache-${var.env}.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.router.dns_name}"]
}

resource "aws_route53_record" "sslproxy" {
  zone_id = "${var.dns_zone_id_external}"
  name = "proxy-${var.env}.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.tsuru-sslproxy-elb.dns_name}"]
}

/* Internal Router CNAME record */
resource "aws_route53_record" "router-int" {
  zone_id = "${var.dns_zone_id_internal}"
  name = "hipache-int-${var.env}.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.router-int.dns_name}"]
}

/* Application router wildcard record */
resource "aws_route53_record" "wildcard" {
  zone_id = "${var.dns_zone_id_external}"
  name = "*.hipache-${var.env}.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  /* enable this to talk to the hipache router directly (HTTP only)
  records = ["${aws_route53_record.router.name}"] */
  /* enable this to talk to the SSL offload proxy (ngnix, HTTP+HTTPS) */
  records = ["${aws_route53_record.sslproxy.name}"]
}

/* API external CNAME record */
resource "aws_route53_record" "api-external" {
  zone_id = "${var.dns_zone_id_external}"
  name = "api-${var.env}.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.api-ext.dns_name}"]
}

/* API internal CNAME record */
resource "aws_route53_record" "api-internal" {
  zone_id = "${var.dns_zone_id_internal}"
  name = "internal.api-${var.env}.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.api-int.dns_name}"]
}

/* Gandalf A record */
resource "aws_route53_record" "gandalf" {
  zone_id = "${var.dns_zone_id_external}"
  name = "gandalf-${var.env}.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.gandalf.public_ip}"]
}

/* NAT A record */
resource "aws_route53_record" "nat" {
  zone_id = "${var.dns_zone_id_external}"
  name = "nat-${var.env}.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.nat.public_ip}"]
}

/* Docker-registry A record */
resource "aws_route53_record" "docker-registry" {
  zone_id = "${var.dns_zone_id_internal}"
  name = "docker-registry-${var.env}.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.docker-registry.private_ip}"]
}

