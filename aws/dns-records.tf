/* Router CNAME record */
resource "aws_route53_record" "router" {
  zone_id = "ZAO40KKT7J2PB"
  name = "hipache.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.router.dns_name}"]
}

resource "aws_route53_record" "sslproxy" {
  zone_id = "ZAO40KKT7J2PB"
  name = "proxy.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.tsuru-sslproxy-elb.dns_name}"]
}

/* Internal Router CNAME record */
resource "aws_route53_record" "router-int" {
  zone_id = "Z3OIOPK20MYIOI"
  name = "hipache-int.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  records = ["${aws_elb.router-int.dns_name}"]
}

/* Application router wildcard record */
resource "aws_route53_record" "wildcard" {
  zone_id = "ZAO40KKT7J2PB"
  name = "*.hipache.tsuru.paas.alphagov.co.uk"
  type = "CNAME"
  ttl = "60"
  /* enable this to talk to the hipache router directly (HTTP only)
  records = ["${aws_route53_record.router.name}"] */
  /* enable this to talk to the SSL offload proxy (ngnix, HTTP+HTTPS) */
  records = ["${aws_route53_record.sslproxy.name}"]
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
/* Docker-registry A record */
resource "aws_route53_record" "docker-registry" {
  zone_id = "ZAO40KKT7J2PB"
  name = "docker-registry.tsuru.paas.alphagov.co.uk"
  type = "A"
  ttl = "60"
  records = ["${aws_instance.docker-registry.private_ip}"]
}

