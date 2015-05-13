/* Router Launch configuration */
resource "aws_instance" "router" {
  count = 2
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-router"
  }
}

/* Router External Load balancer */
resource "aws_elb" "router" {
  name = "${var.env}-tsuru-router-elb"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  instances = ["${aws_instance.router.*.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}

/* Router Internal Load balancer */
resource "aws_elb" "router-int" {
  name = "${var.env}-tsuru-router-elb-int"
  subnets = ["${aws_subnet.private.*.id}"]
  internal = true
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web-int.id}"]
  instances = ["${aws_instance.router.*.id}"]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}
