resource "google_compute_firewall" "internal" {
  name = "${var.env}-tsuru-internal"
  description = "Security group for internally routed traffic"
  network = "${google_compute_network.network1.name}"

  source_tags = [ "public", "private" ]
  target_tags = [ "public", "private" ]

  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
}

resource "google_compute_firewall" "nat" {
  name = "${var.env}-nat-tsuru"
  description = "Security group for nat instances that allows SSH and VPN traffic from internet"
  network = "${google_compute_network.network1.name}"

  source_ranges = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}"]
  target_tags = [ "nat" ]

  allow {
    protocol = "tcp"
    ports = [ 22 ]
  }
}

resource "google_compute_firewall" "gandalf" {
  name = "${var.env}-tsuru-gandalf"
  description = "Security group for Gandalf instance that allows SSH access from internet"
  network = "${google_compute_network.network1.name}"

  source_ranges = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}","${google_compute_instance.nat.network_interface.0.access_config.0.nat_ip}/32"]
  target_tags = [ "gandalf" ]

  allow {
    protocol = "tcp"
    ports = [ 22 ]
  }
}

resource "google_compute_firewall" "web" {
  name = "${var.env}-web-tsuru"
  description = "Security group for web that allows web traffic from internet"
  network = "${google_compute_network.network1.name}"

  source_ranges = [
    "${split(",", var.office_cidrs)}","${var.jenkins_elastic}",
    "${google_compute_instance.nat.network_interface.0.access_config.0.nat_ip}",
    "${google_compute_instance.gandalf.network_interface.0.access_config.0.nat_ip}",
    "${google_compute_instance.nat.network_interface.0.access_config.0.nat_ip}/32",
     "${google_compute_instance.gandalf.network_interface.0.access_config.0.nat_ip}/32",
  ]
  target_tags = [ "web" ]

  allow {
    protocol = "tcp"
    ports = [ 80, 8080, 443 ]
  }
}
resource "google_compute_firewall" "grafana" {
  name = "${var.env}-grafana-tsuru"
  description = "Security group for grafana that allows traffic from the office"
  network = "${google_compute_network.network1.name}"

  source_ranges = [
    "${split(",", var.office_cidrs)}","${var.jenkins_elastic}",
    "${google_compute_instance.nat.network_interface.0.access_config.0.nat_ip}",
    "${google_compute_instance.gandalf.network_interface.0.access_config.0.nat_ip}",
    "${google_compute_instance.nat.network_interface.0.access_config.0.nat_ip}/32",
  ]
  target_tags = [ "grafana" ]

  allow {
    protocol = "tcp"
    ports = [ 3000, 8083 ]
  }
}

