resource "etcd_discovery" "tsuru" {
   size = "${var.coreos_admin_count}"
}

# This requires a ssh tunnel to connect to the remote etcd daemon
#provider "etcd" {
#    endpoint = "http://localhost:2379"
#}

resource "template_file" "coreos-admin-config" {
  depends_on = [ "etcd_discovery.tsuru" ]
  filename = "coreos-admin-config.yaml.tpl"
  vars {
    fleet_metadata = "role=admin"
    etcd_discovery_url = "${etcd_discovery.tsuru.url}"
  }
}

resource "aws_instance" "coreos-admin" {
  depends_on = [ "template_file.coreos-admin-config" ]
  count = "${var.coreos_admin_count}"
  ami = "${lookup(var.coreos_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-coreos-admin-${count.index}"
  }
  user_data = "${template_file.coreos-admin-config.rendered}"

# Code to wait for the machine to be boot
#  connection {
#    user = "core"
#    key_file = "ssh/insecure-deployer"
#  }
#  provisioner "remote-exec" {
#    inline = [ "true" ]
#  }

}


