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
    sshKeys = "${var.user}:${file("${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  tags = [ "private", "web" ]
}

resource "google_compute_target_pool" "api" {
  name = "${var.env}-tsuru-api-lb"
  instances = [ "${google_compute_instance.api.*.self_link}" ]
}
resource "google_compute_address" "api" {
  name = "${var.env}-tsuru-api-lb"
}
resource "google_compute_forwarding_rule" "api_https" {
  name = "${var.env}-tsuru-api-lb-https"
  ip_address = "${google_compute_address.api.address}"
  target = "${google_compute_target_pool.api.self_link}"
  port_range = 443
}
