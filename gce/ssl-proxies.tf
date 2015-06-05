/* FIXME: Unused, remove when deployed to CI */
resource "google_compute_target_pool" "tsuru-sslproxy" {
  name = "${var.env}-tsuru-sslproxy-lb"
  instances = []
  health_checks = []
}
