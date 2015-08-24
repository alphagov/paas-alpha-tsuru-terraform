
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

