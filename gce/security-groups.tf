/* Security group for the nat server */
resource "google_compute_firewall" "nat" {
  name = "nat-tsuru"
  description = "Security group for nat instances that allows SSH and VPN traffic from internet"
  network = "${google_compute_network.network1.name}"

  source_ranges = [ "80.194.77.90/32", "80.194.77.100/32" ]
  target_tags = [ "nat" ]

  allow {
    protocol = "tcp"
    ports = [ 22 ]
  }
}

/* Security group for the Gandalf server */
resource "google_compute_firewall" "gandalf" {
  name = "tsuru-gandalf"
  description = "Security group for Gandalf instance that allows SSH access from internet"
  network = "${google_compute_network.network1.name}"

  source_ranges = [ "80.194.77.90/32", "80.194.77.100/32" ]
  target_tags = [ "gandalf" ]

  allow {
    protocol = "tcp"
    ports = [ 22 ]
  }
}

/* Security group for the web */
resource "google_compute_firewall" "web" {
  name = "web-tsuru"
  description = "Security group for web that allows web traffic from internet"
  network = "${google_compute_network.network1.name}"

  source_ranges = [ "80.194.77.90/32", "80.194.77.100/32" ]
  target_tags = [ "web" ]

  allow {
    protocol = "tcp"
    ports = [ 80, 8080, 443 ]
  }
}
