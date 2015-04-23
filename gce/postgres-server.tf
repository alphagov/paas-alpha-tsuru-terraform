/* Postgres Server Instance */
resource "google_compute_instance" "postgres" {
    name = "tsuru-postgres"
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
    depends_on = [ "google_compute_network.network1" ]
    tags = [ "private" ]
}

