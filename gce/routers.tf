/* Routers */
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
    sshKeys = "${var.user}:${file(\"${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  tags = [ "private", "web" ]
}

/* Router load balancer */
resource "google_compute_target_pool" "router" {
  name = "${var.env}-tsuru-router-lb"
  instances = [ "${google_compute_instance.router.*.self_link}" ]
}
resource "google_compute_forwarding_rule" "router" {
  name = "${var.env}-tsuru-router-lb"
  target = "${google_compute_target_pool.router.self_link}"
  port_range = 80

  provisioner "local-exec" {
    command = "./ensure_gce_dns.sh ${var.dns_zone_id} ${var.env}-hipache.${var.dns_zone_name} 60 A ${google_compute_forwarding_rule.router.ip_address}"
  }
}
