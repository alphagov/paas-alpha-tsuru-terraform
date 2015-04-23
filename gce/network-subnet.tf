/* Networks */
resource "google_compute_network" "network1" {
  name = "tsuru-network1"
  ipv4_range = "${var.network1_cidr}"
}
