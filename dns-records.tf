/* Router CNAME record */
resource "aws_route53_record" "router" {
  zone_id = "ZAO40KKT7J2PB"
  name = "hipache.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.router.dns_name}"]
}

/* Application router wildcard record */
resource "aws_route53_record" "wildcard" {
  zone_id = "ZAO40KKT7J2PB"
  name = "*.hipache.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_route53_record.router.name}"]
}

/* API external CNAME record */
resource "aws_route53_record" "api-external" {
  zone_id = "ZAO40KKT7J2PB"
  name = "api.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.api-ext.dns_name}"]
}

/* API internal CNAME record */
resource "aws_route53_record" "api-internal" {
  zone_id = "ZAO40KKT7J2PB"
  name = "internal.api.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.api-int.dns_name}"]
}

/* Gandalf A record */
resource "aws_route53_record" "gandalf" {
  zone_id = "ZAO40KKT7J2PB"
  name = "gandalf.tsuru.paas.alphagov.co.uk"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.gandalf.public_ip}"]
}

/* NAT A record */
resource "aws_route53_record" "nat" {
  zone_id = "ZAO40KKT7J2PB"
  name = "nat.tsuru.paas.alphagov.co.uk"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.nat.public_ip}"]
}
