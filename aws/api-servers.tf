/* API servers Launch configuration */
resource "aws_launch_configuration" "api" {
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  lifecycle {
    create_before_destroy = true
  }
}

/* API servers Autoscaling Group */
resource "aws_autoscaling_group" "api" {
  availability_zones = ["${var.region}a", "${var.region}b"]
  vpc_zone_identifier = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
  name = "tsuru-api-asg"
  max_size = 2
  min_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = 2
  force_delete = true
  launch_configuration = "${aws_launch_configuration.api.name}"
  load_balancers = ["${aws_elb.api-ext.name}", "${aws_elb.api-int.name}"]
  tag = {
    key = "Name"
    value = "tsuru-api"
    propagate_at_launch = true
  }
}

/* API external Load balancer */
resource "aws_elb" "api-ext" {
  name = "tsuru-api-elb-ext"
  subnets = ["${aws_subnet.public1.id}", "${aws_subnet.public2.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
    ssl_certificate_id = "${var.api_ssl_certificate_id}"
  }
}

/* API internal Load balancer */
resource "aws_elb" "api-int" {
  name = "tsuru-api-elb-int"
  subnets = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
  internal = true
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }
}

