/* Internal security group */
resource "google_compute_firewall" "internal" {
  name = "tsuru-internal-${var.env}"
  description = "Security group for internally routed traffic"
  network = "${google_compute_network.network1.name}"

  source_tags = [ "public", "private" ]
  target_tags = [ "public", "private" ]

  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
}

/* Security group for the nat server */
resource "google_compute_firewall" "nat" {
  name = "nat-tsuru-${var.env}"
  description = "Security group for nat instances that allows SSH and VPN traffic from internet"
  network = "${google_compute_network.network1.name}"

  source_ranges = ["${split(",", var.office_cidrs)}"]
  target_tags = [ "nat" ]

  allow {
    protocol = "tcp"
    ports = [ 22 ]
  }
}

/* Security group for the Gandalf server */
resource "google_compute_firewall" "gandalf" {
  name = "tsuru-gandalf-${var.env}"
  description = "Security group for Gandalf instance that allows SSH access from internet"
  network = "${google_compute_network.network1.name}"

  source_ranges = ["${split(",", var.office_cidrs)}"]
  target_tags = [ "gandalf" ]

  allow {
    protocol = "tcp"
    ports = [ 22 ]
  }
}

/* Security group for the web */
resource "google_compute_firewall" "web" {
  name = "web-tsuru-${var.env}"
  description = "Security group for web that allows web traffic from internet"
  network = "${google_compute_network.network1.name}"

  source_ranges = [
    "${split(",", var.office_cidrs)}",
    "${google_compute_instance.nat.network_interface.0.access_config.0.nat_ip}",
    "${google_compute_instance.gandalf.network_interface.0.access_config.0.nat_ip}",
  ]
  target_tags = [ "web" ]

  allow {
    protocol = "tcp"
    ports = [ 80, 8080, 443 ]
  }
}
