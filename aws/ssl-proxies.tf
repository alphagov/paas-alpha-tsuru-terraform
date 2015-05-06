/* SSL proxy Launch configuration */
resource "aws_instance" "tsuru-sslproxy" {
  count = 2
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.default.id}","${aws_security_group.sslproxy.id}"]
  subnet_id = "${element(aws_subnet.sslproxy.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.sslproxy.*.availability_zone, count.index)}"
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-sslproxy"
  }
}

/* SSL proxy Load balancer */
resource "aws_elb" "tsuru-sslproxy-elb" {
  name = "${var.env}-tsuru-sslproxy-elb"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.sslproxy.id}"]
  instances = ["${aws_instance.tsuru-sslproxy.*.id}"]

  health_check {
    target = "TCP:443"
    interval = "${var.health_check_interval}"
    timeout = "${var.health_check_timeout}"
    healthy_threshold = "${var.health_check_healthy}"
    unhealthy_threshold = "${var.health_check_unhealthy}"
  }
  listener {
    instance_port = 443
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }
  listener {
    instance_port = 80
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }
}
