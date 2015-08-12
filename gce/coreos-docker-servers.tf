resource "google_compute_instance" "coreos-docker" {
  count = "${var.docker_count}"
  depends_on = [ "template_file.etcd_cloud_config" ]
  name = "${var.env}-tsuru-coreos-docker-${count.index}"
  machine_type = "n1-standard-1"
  zone = "${element(split(",", var.gce_zones), count.index)}"
  disk {
    image = "${var.coreos_image}"
  }
  network_interface {
    network = "${google_compute_network.network1.name}"
  }
  metadata {
    sshKeys = "${var.user}:${file("${var.ssh_key_path}")}"
    user-data = "${template_file.etcd_cloud_config.rendered}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  tags = [ "private" ]
}

resource "template_file" "etcd_cloud_config" {
  depends_on = [ "template_file.etcd_discovery_url" ]
  filename = "../coreos-config.yaml.tpl"
  vars {
    etcd_discovery_url = "${file("ETCD_CLUSTER_ID")}"
    docker_registry_host = "${replace(google_dns_record_set.docker-registry.name, "/\.$/", ":${var.registry_port}")}"
  }
}

resource "template_file" "etcd_discovery_url" {
  filename = "/dev/null"
  provisioner {
    local-exec {
      command = "curl https://discovery.etcd.io/new?size=${var.docker_count} > ETCD_CLUSTER_ID"
    }
  }
}
