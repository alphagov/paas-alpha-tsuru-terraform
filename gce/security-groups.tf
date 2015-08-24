resource "google_compute_firewall" "nat-to-internal" {
  name = "${var.env}-tsuru-nat-to-internal"
  description = "Security group for internally routed traffic"
  network = "${google_compute_network.network1.name}"

  source_tags = [ "nat" ]
  target_tags = [ "private", "gandalf", "grafana" ]

  allow {
    protocol = "tcp"
    ports = [22]
  }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
}

resource "google_compute_firewall" "internal-to-nat" {
  name = "${var.env}-tsuru-internal-to-nat"
  description = "Security group for internally routed traffic to nat"
  network = "${google_compute_network.network1.name}"

  source_tags = [ "private" ]
  target_tags = [ "nat" ]

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



resource "google_compute_firewall" "docker-registry" {
    name = "${var.env}-docker-registry-tsuru"
    description = "Firewall rules for internal access to the docker registry servers"
    network = "${google_compute_network.network1.name}"
    source_ranges = [
      "${google_compute_instance.coreos-docker.*.network_interface.0.address}",
    ]
    source_tags = ["docker-node"]
    target_tags = ["docker-registry"]

    allow {
        protocol = "tcp"
        ports = ["6000"]
    }
}
