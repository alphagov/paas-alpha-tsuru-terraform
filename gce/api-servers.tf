/* API server */
resource "google_compute_instance" "tsuru-app" {
  count = 1
  name = "tsuru-app-${count.index}"
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
  name = "tsuru-api"
  port = 8080
  request_path = "/info"
  check_interval_sec = 1
  timeout_sec = 1
}
resource "google_compute_target_pool" "api" {
  name = "tsuru-api-lb"
  instances = [ "${google_compute_instance.tsuru-app.0.self_link}" ]
  health_checks = [ "${google_compute_http_health_check.api.name}" ]
}
resource "google_compute_forwarding_rule" "api" {
  name = "tsuru-api-lb"
  target = "${google_compute_target_pool.api.self_link}"
  port_range = 8080

  provisioner "local-exec" {
    command = "./ensure_gce_dns.sh ${var.dns_zone_name} api.tsuru2.paas.alphagov.co.uk 60 A ${google_compute_forwarding_rule.api.ip_address}"
  }
}
