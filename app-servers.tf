/* API server */
resource "aws_instance" "tsuru-app" {
  count = 1
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private1.id}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "${file(\"cloud-config/app.yml\")}"
  tags = {
    Name = "tsuru-app-${count.index}"
  }
}

/* Docker server */
resource "aws_instance" "tsuru-docker" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private1.id}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "${file(\"cloud-config/app.yml\")}"
  tags = {
    Name = "tsuru-app-docker"
  }
}

/* Gandalf server */
resource "aws_instance" "gandalf" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.public1.id}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.gandalf.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "${file(\"cloud-config/app.yml\")}"
  tags = {
    Name = "tsuru-app-gandalf"
  }
}

/* API external Load balancer */
resource "aws_elb" "api-ext" {
  name = "tsuru-api-elb-ext"
  subnets = ["${aws_subnet.public1.id}", "${aws_subnet.public2.id}"]
  instances = [ "${aws_instance.tsuru-app.0.id}" ]
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
  instances = [ "${aws_instance.tsuru-app.0.id}" ]
  internal = true
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 8080
    lb_protocol = "http"
  }
}

/* Router Launch configuration */
resource "aws_launch_configuration" "router" {
  name = "tsuru_router_config"
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "${file(\"cloud-config/router.yml\")}"
}

/* Router Autoscaling Group */
resource "aws_autoscaling_group" "router" {
  availability_zones = ["${var.region}a", "${var.region}b"]
  vpc_zone_identifier = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
  name = "tsuru-router-asg"
  max_size = 5
  min_size = 2
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = 2
  force_delete = true
  launch_configuration = "${aws_launch_configuration.router.name}"
  load_balancers = ["${aws_elb.router.name}", "${aws_elb.router-int.name}"]
  tag = {
    key = "Name"
    value = "tsuru-app-router"
    propagate_at_launch = true
  }
}

/* Router External Load balancer */
resource "aws_elb" "router" {
  name = "tsuru-router-elb"
  subnets = ["${aws_subnet.public1.id}", "${aws_subnet.public2.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}

/* Router Internal Load balancer */
resource "aws_elb" "router-int" {
  name = "tsuru-router-elb-int"
  subnets = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
  internal = true
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web-int.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
}

