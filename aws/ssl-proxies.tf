/* SSL proxy Launch configuration */
resource "aws_launch_configuration" "tsuru-sslproxy" {
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.default.id}","${aws_security_group.sslproxy.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  lifecycle {
    create_before_destroy = true
  }
}

/* SSL proxy Autoscaling Group */
resource "aws_autoscaling_group" "tsuru-sslproxy-asg" {
  availability_zones = ["${var.region}a", "${var.region}b"]
  vpc_zone_identifier = ["${aws_subnet.sslproxy1.id}", "${aws_subnet.sslproxy2.id}"]
  name = "tsuru-sslproxy-asg"
  max_size = 2
  min_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = 2
  force_delete = true
  launch_configuration = "${aws_launch_configuration.tsuru-sslproxy.name}"
  load_balancers = ["${aws_elb.tsuru-sslproxy-elb.name}"]
  tag = {
    key = "Name"
    value = "tsuru-sslproxy"
    propagate_at_launch = true
  }
}

/* SSL proxy Load balancer */
resource "aws_elb" "tsuru-sslproxy-elb" {
  name = "tsuru-sslproxy-elb"
  subnets = ["${aws_subnet.public1.id}", "${aws_subnet.public2.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.sslproxy.id}"]
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
