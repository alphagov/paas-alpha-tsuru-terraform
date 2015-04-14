/* Networks */
resource "google_compute_network" "default" {
  name = "${var.gce_net_name}"
  ipv4_range = "${var.gce_net_range}"
}

resource "google_compute_address" "default" {
  count = 3
  name = "tsuru-app-${count.index}"
}

/* App Servers */
resource "google_compute_instance" "default" {
    count = "3"
    name = "tsuru-app-${count.index}"
    machine_type = "n1-standard-1"
    zone = "${var.gce_zone}"
    tags = ["foo", "bar"]

    disk {
        image = "ubuntu-1404-trusty-v20150316"
    }

    network_interface {
        network = "${var.gce_net_name}"
        access_config {
            #nat_ip = ("tsuru-app-${count.index}")
        }
    }

    metadata {
        sshKeys = "${var.user}:${file(\"~/.ssh/id_rsa.pub\")}"
    }

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }
}

/* Define a health check for app servers */
resource "google_compute_http_health_check" "default" {
    name = "http-check"
    request_path = "/"
    check_interval_sec = 1
    timeout_sec = 1
}

/* Load Balancer */
resource "google_compute_target_pool" "default" {
    name = "tsuru-test-lb"
    # Horrible hack on this intsnaces line below as terraform lacks the ability to iterate over a list.
    instances = [ "${var.gce_zone}/tsuru-app-0", "${var.gce_zone}/tsuru-app-1", "${var.gce_zone}/tsuru-app-2" ]
    health_checks = [ "${google_compute_http_health_check.default.name}" ]
}


