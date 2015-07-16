resource "google_compute_instance" "nat" {
  name = "${var.env}-tsuru-nat"
  machine_type = "n1-standard-1"
  zone = "${element(split(",", var.gce_zones), count.index)}"
  disk {
    image = "${var.os_image}"
  }
  network_interface {
    network = "${google_compute_network.network1.name}"
    access_config {
    }
  }
  metadata {
    sshKeys = "${var.user}:${file("${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }

  can_ip_forward = true
  connection {
    user = "${var.user}"
    key_file = "ssh/insecure-deployer"
  }
  provisioner "remote-exec" {
    script = "../setup-nat-routing.sh"
  }
  tags = [ "public", "nat" ]
}
