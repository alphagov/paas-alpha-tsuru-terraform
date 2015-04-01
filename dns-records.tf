/* Router CNAME record */
resource "aws_route53_record" "router" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name = "hipache.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.router.dns_name}"]
}

/* Wildcard CNAME record */
resource "aws_route53_record" "wildcard" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name = "*.hipache.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_route53_record.router.name}"]
}

/* Public Hosted Zone */
resource "aws_route53_zone" "public" {
   name = "tsuru.paas.alphagov.co.uk"
}
