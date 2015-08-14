#resource "etcd_keys" "router" {
#    depends_on = [ "aws_instance.coreos-admin" ]
#    key {
#        name = "router_count"
#        path = "routers/count"
#        default = "3"
#    }
#}

resource "template_file" "coreos-router-config" {
  filename = "coreos-router-config.yaml.tpl"
  vars {
    etcd_servers = "http://${aws_instance.coreos-admin.0.private_ip}:2379"
    fleet_metadata = "role=router,platform=aws"
  }
}

resource "aws_instance" "coreos-router" {
#  depends_on = [ "etcd_keys.router" ]
#  count = "${etcd_keys.router.var.router_count}"
  count = "${var.coreos_router_count}"
  ami = "${lookup(var.coreos_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-coreos-router-${count.index}"
  }
  user_data = "${template_file.coreos-router-config.rendered}"
}


