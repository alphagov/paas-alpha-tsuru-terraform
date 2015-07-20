resource "google_compute_instance" "postgres" {
  count=2
  name = "${var.env}-tsuru-postgres-${count.index}"
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
  tags = [ "private" ]
}

resource "google_storage_bucket" "postgres-gcs" {
    name = "${var.env}-${var.postgres_bucketname}"
    predefined_acl = "projectPrivate"
    location = "EU"
}
