/* API server */
resource "google_compute_instance" "api" {
  count = 2
  name = "${var.env}-tsuru-api-${count.index}"
  machine_type = "n1-standard-1"
  zone = "${element(split(",", var.gce_zones), count.index)}"
  disk {
    image = "${var.os_image}"
  }
  network_interface {
    network = "${google_compute_network.network1.name}"
  }
  metadata {
    sshKeys = "${var.user}:${file(\"${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  tags = [ "private", "web" ]
}

/* API load balancer */
resource "google_compute_http_health_check" "api" {
  name = "${var.env}-tsuru-api"
  port = 8080
  request_path = "/info"
  check_interval_sec = "${var.health_check_interval}"
  timeout_sec = "${var.health_check_timeout}"
  healthy_threshold = "${var.health_check_healthy}"
  unhealthy_threshold = "${var.health_check_unhealthy}"
}
resource "google_compute_target_pool" "api" {
  name = "${var.env}-tsuru-api-lb"
  instances = [ "${google_compute_instance.api.*.self_link}" ]
  health_checks = [ "${google_compute_http_health_check.api.name}" ]
}
resource "google_compute_forwarding_rule" "api" {
  name = "${var.env}-tsuru-api-lb"
  target = "${google_compute_target_pool.api.self_link}"
  port_range = 8080
}
