/* Docker Registry */
resource "google_compute_instance" "docker-registry" {
  name = "docker-registry"
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
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  tags = [ "private" ]

  provisioner "local-exec" {
    command = "./ensure_gce_dns.sh ${var.dns_zone_name} docker-registry.tsuru2.paas.alphagov.co.uk 60 A ${google_compute_instance.docker-registry.network_interface.0.address}"
  }
}
