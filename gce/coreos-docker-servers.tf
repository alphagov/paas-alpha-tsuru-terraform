resource "google_compute_instance" "coreos-docker" {
  depends_on = [ "template_file.etcd_cloud_config" ]
  count = "${var.docker_count}"
  name = "${element(template_file.etcd_cloud_config.*.vars.telegraf_tag_instance_name, count.index)}"
  machine_type = "n1-standard-1"
  zone = "${element(split(",", var.gce_zones), count.index)}"
  disk {
    image = "${var.coreos_image}"
  }
  network_interface {
    network = "${google_compute_network.network1.name}"
  }
  metadata {
    sshKeys = "core:${file("${var.ssh_key_path}")}"
    user_data = "${element(template_file.etcd_cloud_config.*.rendered, count.index)}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  tags = [ "private", "docker-node" ]
}

resource "template_file" "etcd_cloud_config" {
  depends_on = [ "template_file.etcd_discovery_url" ]
  count = "${var.docker_count}"
  filename = "../coreos-config.yaml.tpl"
  vars {
    etcd_discovery_url = "${file("ETCD_CLUSTER_ID")}"
    docker_registry_host = "${replace(google_dns_record_set.docker-registry.name, "/\.$/", ":${var.registry_port}")}"
    influx_db_host = "${google_compute_instance.influx-grafana.network_interface.0.address}"
    telegraf_tag_instance_name = "${var.env}-tsuru-coreos-docker-${count.index}"
    telegraf_tag_type = "coreos-docker"
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
