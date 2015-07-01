resource "google_compute_instance" "influx-grafana" {
  name = "${var.env}-influx-grafana"
  machine_type = "n1-standard-1"
  zone = "${element(split(",", var.gce_zones), count.index)}"
  disk {
    image = "${var.os_image}"
    size = 100
  }
  network_interface {
    network = "${google_compute_network.network1.name}"
  }
  metadata {
    sshKeys = "${var.user}:${file(\"${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-rw", "userinfo-email" ]
  }
  tags = [ "public", "web" ]
}

