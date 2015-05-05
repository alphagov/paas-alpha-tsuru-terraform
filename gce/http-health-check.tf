resource "google_compute_http_health_check" "http-check" {
  name = "${var.env}-http-check"
  request_path = "/"
  check_interval_sec = 1
  timeout_sec = 1
}
