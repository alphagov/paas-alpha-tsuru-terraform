resource "google_compute_firewall" "internal" {
  name = "${var.env}-tsuru-internal"
  description = "Security group for internally routed traffic"
  network = "${google_compute_network.network1.name}"

  source_tags = [ "public", "private" ]
  target_tags = [ "public", "private" ]

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

  source_tags = [ "public", "private" ]
  target_tags = [ "public", "nat" ]

  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
}

resource "google_compute_firewall" "router" {
  name = "${var.env}-router-tsuru"
  description = "Security group for router traffic"
  network = "${google_compute_network.network1.name}"

  source_ranges = [
    "${google_compute_instance.coreos-docker.*.network_interface.0.address}"
  ]
  source_tags = [ "router" ]
  target_tags = [ "docker-node" ]

  allow {
    protocol = "tcp"
    ports = ["1024-65535"]
  }

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

resource "google_compute_firewall" "influxdb" {
  name = "${var.env}-influxdb-tsuru"
  description = "Security group for influxdb that allows inbound traffic from all private machines"
  network = "${google_compute_network.network1.name}"


  source_tags = [ "private" ]
  target_tags = [ "influxdb" ]

  allow {
    protocol = "tcp"
    ports = [ 8086 ]
  }
}

resource "google_compute_firewall" "api" {
    name = "${var.env}-api-tsuru"
    description = "Firewall rules for internal access to the api servers"
    network = "${google_compute_network.network1.name}"
    source_ranges = [
      "${google_compute_instance.gandalf.network_interface.0.address}"
    ]
    source_tags = ["gandalf"]
    target_tags = ["api"]

    allow {
        protocol = "tcp"
        ports = ["80"]
    }
}

resource "google_compute_firewall" "mongodb" {
    name = "${var.env}-mongodb-tsuru"
    description = "Firewall rules for internal access to the mongodb servers"
    network = "${google_compute_network.network1.name}"
    source_ranges = [
      "${google_compute_instance.api.*.network_interface.0.address}"
    ]
    source_tags = ["api", "gandalf"]
    target_tags = ["mongo"]

    allow {
        protocol = "tcp"
        ports = ["27017"]
    }
}

resource "google_compute_firewall" "redis" {
    name = "${var.env}-redis-tsuru"
    description = "Firewall rules for internal access to the redis servers"
    network = "${google_compute_network.network1.name}"
    source_ranges = [
      "${google_compute_instance.api.*.network_interface.0.address}",
      "${google_compute_instance.router.*.network_interface.0.address}"
    ]
    source_tags = ["api", "router"]
    target_tags = ["redis"]

    allow {
        protocol = "tcp"
        ports = ["6379"]
    }
}

resource "google_compute_firewall" "postgres" {
    name = "${var.env}-postgres-tsuru"
    description = "Firewall rules for internal access to the postgreSQL servers"
    network = "${google_compute_network.network1.name}"
    source_ranges = [
      "${google_compute_instance.api.*.network_interface.0.address}",
      "${google_compute_instance.coreos-docker.*.network_interface.0.address}"
    ]
    source_tags = ["api", "docker-node", "postgres"]
    target_tags = ["postgres"]

    allow {
        protocol = "tcp"
        ports = ["5432"]
    }
}

resource "google_compute_firewall" "docker-node" {
    name = "${var.env}-docker-node-tsuru"
    description = "Firewall rules for internal access to the docker servers"
    network = "${google_compute_network.network1.name}"
    source_ranges = [
      "${google_compute_instance.api.*.network_interface.0.address}",
      "${google_compute_instance.gandalf.network_interface.0.address}"
    ]
    source_tags = ["api", "gandalf"]
    target_tags = ["docker-node"]

    allow {
        protocol = "tcp"
        ports = ["4243"]
    }
}

resource "google_compute_firewall" "docker-node-healthcheck" {
    name = "${var.env}-docker-node-healthcheck-tsuru"
    description = "Firewall rules for internal access to the docker servers for healthcheck"
    network = "${google_compute_network.network1.name}"
    source_ranges = [
      "${google_compute_instance.api.*.network_interface.0.address}"
    ]
    source_tags = ["api"]
    target_tags = ["docker-node"]

    allow {
        protocol = "tcp"
        ports = ["1024-65535"]
    }
}

resource "google_compute_firewall" "docker-registry" {
    name = "${var.env}-docker-registry-tsuru"
    description = "Firewall rules for internal access to the docker registry servers"
    network = "${google_compute_network.network1.name}"
    source_ranges = [
      "${google_compute_instance.coreos-docker.*.network_interface.0.address}",
      "${google_compute_instance.api.*.network_interface.0.address}"
    ]
    source_tags = ["docker-node"]
    target_tags = ["docker-registry"]

    allow {
        protocol = "tcp"
        ports = ["6000"]
    }
}

