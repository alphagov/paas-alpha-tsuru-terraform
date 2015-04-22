/* Networks */
resource "google_compute_network" "private1" {
  name = "tsuru-private1"
  ipv4_range = "${var.private_subnet1_cidr}"
}



