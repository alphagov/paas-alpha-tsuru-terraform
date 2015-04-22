/* Postgres Server Instance */
resource "google_compute_instance" "postgres" {
    name = "tsuru-postgres"
    machine_type = "n1-standard-1"
    zone = "${var.gce_zone}"
    disk {
        image = "${var.os_image}"
    }
    network_interface {
        network = "${google_compute_network.private1.name}"
        access_config {
            #nat_ip = ("tsuru-app-${count.index}")
        }
    }
    metadata {
        sshKeys = "${var.user}:${file(\"${var.ssh_key_path}")}"
    }
    service_account {
        scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
    }
    depends_on = [ "google_compute_network.private1" ]
}

