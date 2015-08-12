resource "aws_instance" "coreos-docker" {
  depends_on = [ "template_file.etcd_cloud_config" ]
  count = "${var.docker_count}"
  ami = "${lookup(var.coreos, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-coreos-docker-${count.index}"
  }
  user_data = "${template_file.etcd_cloud_config.rendered}"
}

resource "template_file" "etcd_cloud_config" {
  depends_on = [ "template_file.etcd_discovery_url" ]
  filename = "../coreos-config.yaml.tpl"
  vars {
    etcd_discovery_url = "${file("ETCD_CLUSTER_ID")}"
    docker_registry_host = "${replace(aws_route53_record.docker-registry.name, "/\.$/", ":${var.registry_port}")}"
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
