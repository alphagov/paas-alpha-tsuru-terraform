resource "google_compute_http_health_check" "http-check" {
  name = "${var.env}-http-check"
  request_path = "/"
  check_interval_sec = "${var.health_check_interval}"
  timeout_sec = "${var.health_check_timeout}"
  healthy_threshold = "${var.health_check_healthy}"
  unhealthy_threshold = "${var.health_check_unhealthy}"
}
