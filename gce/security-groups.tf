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
