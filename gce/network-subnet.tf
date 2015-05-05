/* Networks */
resource "google_compute_network" "network1" {
  name = "${var.env}-tsuru-network1"
  ipv4_range = "${var.network1_cidr}"
}

resource "google_compute_route" "private_default" {
  name = "${var.env}-private-default"
  dest_range = "0.0.0.0/0"
  network = "${google_compute_network.network1.name}"
  next_hop_instance = "${google_compute_instance.nat.name}"
  next_hop_instance_zone = "${google_compute_instance.nat.zone}"
  priority = 1
  tags = [ "private" ]
}
