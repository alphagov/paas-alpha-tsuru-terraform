resource "aws_instance" "api" {
  count = 2
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-api"
  }
}

resource "aws_elb" "api-ext" {
  name = "${var.env}-tsuru-api-elb-ext"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  instances = ["${aws_instance.api.*.id}"]

  health_check {
    target = "HTTPS:443/info"
    interval = "${var.health_check_interval}"
    timeout = "${var.health_check_timeout}"
    healthy_threshold = "${var.health_check_healthy}"
    unhealthy_threshold = "${var.health_check_unhealthy}"
  }
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }
  listener {
    instance_port = 443
    instance_protocol = "tcp"
    lb_port = 443
    lb_protocol = "tcp"
  }
}

resource "aws_elb" "api-int" {
  name = "${var.env}-tsuru-api-elb-int"
  subnets = ["${aws_subnet.private.*.id}"]
  internal = true
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  instances = ["${aws_instance.api.*.id}"]

  health_check {
    target = "HTTP:8080/info"
    interval = "${var.health_check_interval}"
    timeout = "${var.health_check_timeout}"
    healthy_threshold = "${var.health_check_healthy}"
    unhealthy_threshold = "${var.health_check_unhealthy}"
  }
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }
}
