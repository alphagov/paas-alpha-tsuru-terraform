resource "aws_instance" "coreos-redis" {
  depends_on = ["template_file.etcd_cloud_config_redis"] 
  count = "${var.redis_count}"
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
    Name = "${var.env}-tsuru-coreos-redis-${count.index}"
  }
  user_data = "${element(template_file.etcd_cloud_config_redis.*.rendered, count.index)}"
}

resource "template_file" "etcd_cloud_config_redis" {
  depends_on = [ "template_file.redis_etcd_discovery_url" ]
  count = "${var.docker_count}"
  filename = "../redis-coreos-config.yaml.tpl"
  vars {
    redis_etcd_discovery_url = "${file("REDIS_ETCD_CLUSTER_ID")}"
    docker_registry_host = "${replace(aws_route53_record.docker-registry.name, "/\.$/", ":${var.registry_port}")}"
    influx_db_host = "${aws_instance.influx-grafana.private_ip}"
    telegraf_tag_instance_name = "${var.env}-tsuru-coreos-redis-${count.index}"
    telegraf_tag_type = "coreos-redis"
  }
}

resource "template_file" "redis_etcd_discovery_url" {
  filename = "/dev/null"
  provisioner {
    local-exec {
      command = "curl https://discovery.etcd.io/new?size=${var.docker_count} > REDIS_ETCD_CLUSTER_ID"
    }
  }
}

resource "aws_security_group" "redis_node" {
  name = "${var.env}-redis-node"
  description = "Redis Node security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
      from_port = 1024
      to_port = 65535
      protocol = "tcp"
      security_groups = [
        "${aws_security_group.tsuru_api.id}"
      ]
  }

  ingress {
      from_port = 1024
      to_port = 4242
      protocol = "tcp"
      security_groups = [
        "${aws_security_group.router.id}"
      ]
  }

  ingress {
      from_port = 4244
      to_port = 65535
      protocol = "tcp"
      security_groups = [
        "${aws_security_group.router.id}"
      ]
  }

  tags = {
    Name = "${var.env}-tsuru-coreos-redis"
  }
}
