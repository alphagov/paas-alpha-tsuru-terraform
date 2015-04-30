/* SSL proxy */
resource "google_compute_instance" "tsuru-sslproxy" {
  count = 2
  name = "tsuru-sslproxy-${count.index}"
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

/* SSL proxy load balancer */
resource "google_compute_target_pool" "tsuru-sslproxy" {
  name = "tsuru-sslproxy-lb"
  instances = [ "${google_compute_instance.tsuru-sslproxy.*.self_link}" ]
  health_checks = [ "${google_compute_http_health_check.http-check.name}" ]
}
resource "google_compute_address" "tsuru-sslproxy" {
  name = "tsuru-sslproxy"

  provisioner "local-exec" {
    command = "./ensure_gce_dns.sh ${var.dns_zone_id} proxy.${var.dns_zone_name} 60 A ${google_compute_address.tsuru-sslproxy.address}"
  }
  provisioner "local-exec" {
    command = "./ensure_gce_dns.sh ${var.dns_zone_id} *.hipache.${var.dns_zone_name} 60 CNAME proxy.${var.dns_zone_name}."
  }
}
resource "google_compute_forwarding_rule" "tsuru-sslproxy-443" {
  name = "tsuru-sslproxy-lb443"
  target = "${google_compute_target_pool.tsuru-sslproxy.self_link}"
  port_range = 443
  ip_address = "${google_compute_address.tsuru-sslproxy.address}"
}
resource "google_compute_forwarding_rule" "tsuru-sslproxy-80" {
  name = "tsuru-sslproxy-lb80"
  target = "${google_compute_target_pool.tsuru-sslproxy.self_link}"
  port_range = 80
  ip_address = "${google_compute_address.tsuru-sslproxy.address}"
}
