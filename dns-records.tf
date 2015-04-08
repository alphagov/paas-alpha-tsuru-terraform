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

/* API CNAME record */
resource "aws_route53_record" "api" {
  zone_id = "ZAO40KKT7J2PB"
  name = "api.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.api-ext.dns_name}"]
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
