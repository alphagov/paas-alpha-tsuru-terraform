/* Router CNAME record */
resource "aws_route53_record" "router" {
  zone_id = "ZAO40KKT7J2PB"
  name = "hipache.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.router.dns_name}"]
}

