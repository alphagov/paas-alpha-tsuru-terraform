/*
  This file contains resources that aren't in use but can't be deleted in a
  single run because of dependency ordering. They should be removed from
  this file at the earliest convenience after deploying to all existing
  environments.
*/

resource "aws_launch_configuration" "api" {
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
}

resource "aws_launch_configuration" "router" {
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
}

resource "aws_launch_configuration" "tsuru-sslproxy" {
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.default.id}","${aws_security_group.sslproxy.id}"]
  key_name = "${var.key_pair_name}"
}
