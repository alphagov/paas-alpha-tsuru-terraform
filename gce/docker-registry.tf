resource "google_compute_instance" "docker-registry" {
  name = "${var.env}-tsuru-registry"
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
    sshKeys = "${var.user}:${file("${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-rw", "userinfo-email" ]
  }
  tags = [ "private", "docker-registry" ]
}

resource "google_storage_bucket" "registry-gcs" {
    name = "${var.env}-${var.registry_gcs_bucketname}"
    predefined_acl = "${var.registry_gcs_bucketname_acl}"
    location = "${var.gcs_region}"
    force_destroy = "${var.force_destroy}"
}

resource "google_storage_bucket" "registry-gcs" {
    name = "${var.env}-${var.registry_gcs_bucketname}"
    predefined_acl = "${var.registry_gcs_bucketname_acl}"
    location = "${var.gcs_region}"
}
