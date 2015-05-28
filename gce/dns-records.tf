resource "google_dns_record_set" "router" {
  managed_zone = "${var.dns_zone_id}"
  name = "${var.env}-hipache.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  rrdatas = ["${google_compute_forwarding_rule.router.ip_address}"]
}

resource "google_dns_record_set" "sslproxy" {
  managed_zone = "${var.dns_zone_id}"
  name = "${var.env}-proxy.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  rrdatas = ["${google_compute_address.tsuru-sslproxy.address}"]
}

resource "google_dns_record_set" "wildcard" {
  managed_zone = "${var.dns_zone_id}"
  name = "*.${var.env}-hipache.${var.dns_zone_name}"
  type = "CNAME"
  ttl = "60"
  /* enable this to talk to the hipache router directly (HTTP only)
  rrdatas = ["${google_dns_record_set.router.name}"] */
  /* enable this to talk to the SSL offload proxy (ngnix, HTTP+HTTPS) */
  rrdatas = ["${google_dns_record_set.sslproxy.name}"]
}

resource "google_dns_record_set" "api" {
  managed_zone = "${var.dns_zone_id}"
  name = "${var.env}-api.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  rrdatas = ["${google_compute_forwarding_rule.api.ip_address}"]
}

resource "google_dns_record_set" "gandalf" {
  managed_zone = "${var.dns_zone_id}"
  name = "${var.env}-gandalf.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  rrdatas = ["${google_compute_instance.gandalf.network_interface.0.access_config.0.nat_ip}"]
}

resource "google_dns_record_set" "nat" {
  managed_zone = "${var.dns_zone_id}"
  name = "${var.env}-nat.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  rrdatas = ["${google_compute_instance.nat.network_interface.0.access_config.0.nat_ip}"]
}

resource "google_dns_record_set" "docker-registry" {
  managed_zone = "${var.dns_zone_id}"
  name = "${var.env}-docker-registry.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  rrdatas = ["${google_compute_instance.docker-registry.network_interface.0.address}"]
}
