resource "aws_instance" "api" {
  count = 2
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.tsuru_api.id}"
  ]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-api-${count.index}"
  }
}

resource "aws_elb" "api-ext" {
  name = "${var.env}-tsuru-api-elb-ext"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = [
    "${aws_security_group.web.id}",
    "${aws_security_group.tsuru_api_external_loadbalancer.id}"
  ]
  instances = ["${aws_instance.api.*.id}"]

  health_check {
    target = "HTTPS:443/info"
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
}

resource "aws_elb" "api-int" {
  name = "${var.env}-tsuru-api-elb-int"
  subnets = ["${aws_subnet.private.*.id}"]
  internal = true
  security_groups = [
    "${aws_security_group.web.id}",
    "${aws_security_group.tsuru_api_internal_loadbalancer.id}"
  ]
  instances = ["${aws_instance.api.*.id}"]

  health_check {
    target = "HTTPS:443/info"
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
}

resource "aws_security_group" "tsuru_api_external_loadbalancer" {
  name = "${var.env}-tsuru-api-external-loadbalancer"
  description = "Tsuru API external load balancer security group"
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "${var.env}-tsuru-api-external-loadbalancer"
  }
}

resource "aws_security_group" "tsuru_api_internal_loadbalancer" {
  name = "${var.env}-tsuru-api-internal-loadbalancer"
  description = "Tsuru API internal load balancer security group"
  vpc_id = "${aws_vpc.default.id}"

  tags = {
    Name = "${var.env}-tsuru-api-internal-loadbalancer"
  }
}

resource "aws_security_group" "tsuru_api" {
  name = "${var.env}-tsuru-api"
  description = "Tsuru API security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.tsuru_api_external_loadbalancer.id}",
      "${aws_security_group.tsuru_api_internal_loadbalancer.id}"
    ]
  }

  tags = {
    Name = "${var.env}-tsuru-api"
  }
}
