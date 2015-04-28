/* Gandalf server */
resource "google_compute_instance" "gandalf" {
  name = "tsuru-app-gandalf"
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
    sshKeys = "${var.user}:${file(\"${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  tags = [ "public", "gandalf" ]

  provisioner "local-exec" {
    command = "./ensure_gce_dns.sh ${var.dns_zone_name} gandalf.tsuru2.paas.alphagov.co.uk 60 A ${google_compute_instance.gandalf.network_interface.0.access_config.0.nat_ip}"
  }
}
