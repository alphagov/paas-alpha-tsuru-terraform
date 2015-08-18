resource "google_compute_instance" "router" {
  count = 2
  name = "${var.env}-tsuru-router-${count.index}"
  machine_type = "n1-standard-1"
  zone = "${element(split(",", var.gce_zones), count.index)}"
  disk {
    image = "${var.os_image}"
  }
  network_interface {
    network = "${google_compute_network.network1.name}"
  }
  metadata {
    sshKeys = "${var.user}:${file("${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  tags = [ "private", "web", "router" ]
}

resource "google_compute_target_pool" "router" {
  name = "${var.env}-tsuru-router-lb"
  instances = [ "${google_compute_instance.router.*.self_link}" ]
}
resource "google_compute_address" "router" {
  name = "${var.env}-tsuru-router-lb"
}
resource "google_compute_forwarding_rule" "router_http" {
  name = "${var.env}-tsuru-router-lb-http"
  ip_address = "${google_compute_address.router.address}"
  target = "${google_compute_target_pool.router.self_link}"
  port_range = 80
}
resource "google_compute_forwarding_rule" "router_https" {
  name = "${var.env}-tsuru-router-lb-https"
  ip_address = "${google_compute_address.router.address}"
  target = "${google_compute_target_pool.router.self_link}"
  port_range = 443
}
