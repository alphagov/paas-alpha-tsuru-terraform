/* Networks */
resource "google_compute_network" "public1" {
  name = "tsuru-public1"
  ipv4_range = "${var.public_subnet1_cidr}"
}



