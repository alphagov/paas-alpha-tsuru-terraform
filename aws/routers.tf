resource "aws_instance" "router" {
  count = 2
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.router.id}"
  ]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-router-${count.index}"
  }
}

resource "aws_elb" "router" {
  name = "${var.env}-tsuru-router-elb"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  instances = ["${aws_instance.router.*.id}"]

  health_check {
    target = "TCP:443"
    interval = "${var.health_check_interval}"
    timeout = "${var.health_check_timeout}"
    healthy_threshold = "${var.health_check_healthy}"
    unhealthy_threshold = "${var.health_check_unhealthy}"
  }
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  listener {
    instance_port = 443
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }
}

resource "aws_security_group" "router" {
  name = "router"
  description = "Router security group"
  vpc_id = "${aws_vpc.default.id}"
}
