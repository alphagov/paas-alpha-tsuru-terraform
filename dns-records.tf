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

/* Gandalf A record */
resource "aws_route53_record" "gandalf" {
  zone_id = "ZAO40KKT7J2PB"
  name = "gandalf.tsuru.paas.alphagov.co.uk"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.gandalf.public_ip}"]
}
