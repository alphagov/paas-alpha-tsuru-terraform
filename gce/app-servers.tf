/* API and Docker servers */
resource "google_compute_instance" "tsuru-app" {
  count = 2
  name = "tsuru-app-${count.index}"
  machine_type = "n1-standard-1"
  zone = "${var.gce_zone}"
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
  depends_on = [ "google_compute_network.network1" ]
  tags = [ "private", "web" ]
}

/* Gandalf server */
resource "google_compute_instance" "gandalf" {
  name = "tsuru-app-gandalf"
  machine_type = "n1-standard-1"
  zone = "${var.gce_zone}"
  disk {
    image = "${var.os_image}"
  }
  network_interface {
    network = "${google_compute_network.network1.name}"
    access_config {}
  }
  metadata {
    sshKeys = "${var.user}:${file(\"${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  depends_on = [ "google_compute_network.network1" ]
  tags = [ "public", "gandalf" ]
}

/* API load balancer */
resource "google_compute_target_pool" "api" {
  name = "tsuru-api-lb"
  instances = [ "${google_compute_instance.tsuru-app.*.self_link}" ]
  health_checks = [ "${google_compute_http_health_check.http-check.name}" ]
}
resource "google_compute_forwarding_rule" "api" {
  name = "tsuru-api-lb"
  target = "${google_compute_target_pool.api.self_link}"
  port_range = 8080

  provisioner "local-exec" {
    command = "./ensure_gce_dns.sh ${var.dns_zone_name} api.tsuru2.paas.alphagov.co.uk 60 A ${google_compute_forwarding_rule.api.ip_address}"
  }
}

/* Routers */
resource "google_compute_instance" "router" {
  count = 2
  name = "tsuru-router-${count.index}"
  machine_type = "n1-standard-1"
  zone = "${var.gce_zone}"
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
  depends_on = [ "google_compute_network.network1" ]
  tags = [ "private", "web" ]
}

/* API load balancer */
resource "google_compute_target_pool" "router" {
  name = "tsuru-router-lb"
  instances = [ "${google_compute_instance.router.*.self_link}" ]
  health_checks = [ "${google_compute_http_health_check.http-check.name}" ]
}
resource "google_compute_forwarding_rule" "router" {
  name = "tsuru-router-lb"
  target = "${google_compute_target_pool.router.self_link}"
  port_range = 80
}
