resource "google_compute_instance" "gandalf" {
  name = "${var.env}-tsuru-gandalf"
  machine_type = "n1-standard-1"
  zone = "${element(split(",", var.gce_zones), count.index)}"
  disk {
    image = "${var.os_image}"
  }
  network_interface {
    network = "${google_compute_network.network1.name}"
    access_config {}
  }
  metadata {
    sshKeys = "${var.user}:${file("${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  tags = [ "public", "gandalf" ]
}
