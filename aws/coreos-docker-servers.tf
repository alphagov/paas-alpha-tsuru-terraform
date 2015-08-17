resource "aws_instance" "coreos-docker" {
  depends_on = [ "template_file.etcd_cloud_config" ]
  count = "${var.docker_count}"
  ami = "${lookup(var.coreos_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.docker_node.id}"
  ]
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

resource "aws_security_group" "docker_node" {
  name = "${var.env}-docker-node"
  description = "Docker Node security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      security_groups = [
        "${aws_security_group.tsuru_api.id}",
        "${aws_security_group.router.id}"
      ]
  }

  tags = {
    Name = "${var.env}-tsuru-coreos-docker"
  }
}
