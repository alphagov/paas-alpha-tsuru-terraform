/* Docker-registry Launch configuration */
resource "aws_launch_configuration" "docker-registry" {
  name = "docker_registry_config"
  image_id = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "${file(\"cloud-config/docker-registry.yml\")}"
}

/* Docker-registry Autoscaling Group */
resource "aws_autoscaling_group" "docker-registry" {
  availability_zones = ["${var.region}a", "${var.region}b"]
  vpc_zone_identifier = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
  name = "tsuru-docker-registry"
  max_size = 1
  min_size = 1
  health_check_grace_period = 300
  health_check_type = "EC2"
  desired_capacity = 1
  force_delete = true
  launch_configuration = "${aws_launch_configuration.docker-registry.name}"
  load_balancers = ["${aws_elb.docker-registry.name}"]
  /* To be added after v0.4.0
  tag = {
    key = "Name"
    value = "tsuru-docker-registry"
    propagate_at_launch = true
  }
  */
}

/* Docker-registry internal Load balancer */
resource "aws_elb" "docker-registry" {
  name = "docker-registry"
  subnets = ["${aws_subnet.private1.id}", "${aws_subnet.private2.id}"]
  security_groups = ["${aws_security_group.default.id}"]
  internal = true
  listener {
    instance_port = 6000
    instance_protocol = "tcp"
    lb_port = 6000
    lb_protocol = "tcp"
  }
}
