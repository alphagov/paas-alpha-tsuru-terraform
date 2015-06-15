resource "google_dns_record_set" "wildcard" {
  managed_zone = "${var.dns_zone_id}"
  name = "*.${var.env}-hipache.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  rrdatas = ["${google_compute_forwarding_rule.router_https.ip_address}"]
}

resource "google_dns_record_set" "api" {
  managed_zone = "${var.dns_zone_id}"
  name = "${var.env}-api.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  rrdatas = ["${google_compute_address.api.address}"]
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

resource "google_dns_record_set" "postgresapi" {
  managed_zone = "${var.dns_zone_id}"
  name = "${var.env}-postgresapi.${var.dns_zone_name}"
  type = "A"
  ttl = "60"
  rrdatas = ["${google_compute_forwarding_rule.router_https.ip_address}"]
}
