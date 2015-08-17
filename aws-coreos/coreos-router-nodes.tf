#resource "etcd_keys" "router" {
#    depends_on = [ "aws_instance.coreos-admin" ]
#    key {
#        name = "router_count"
#        path = "routers/count"
#        default = "3"
#    }
#}

resource "template_file" "coreos-router-config" {
  filename = "coreos-router-config.yaml.tpl"
  vars {
    etcd_servers = "http://${aws_instance.coreos-admin.0.private_ip}:2379"
    fleet_metadata = "role=router,platform=aws"
  }
}

resource "aws_instance" "coreos-router" {
#  depends_on = [ "etcd_keys.router" ]
#  count = "${etcd_keys.router.var.router_count}"
  count = "${var.coreos_router_count}"
  ami = "${lookup(var.coreos_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-coreos-router-${count.index}"
  }
  user_data = "${template_file.coreos-router-config.rendered}"
}

resource "aws_elb" "coreos_static_router" {
  name = "${var.env}-tsuru-ra-elb"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  instances = ["${aws_instance.coreos-router.*.id}"]

  health_check {
    target = "TCP:8080"
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


#
# These resources are commented because not all of us have access to create
# and modify things in IAM. This has been run once by dcarley and remains
# here for reference or future modification.
#
# resource "aws_iam_role" "elb-presence" {
#   name = "${var.elb_presence_rolename}"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": { "Service": "ec2.amazonaws.com" },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }
#
# resource "aws_iam_role_policy" "elb-presence" {
#   name   = "${var.elb_presence_rolename}"
#   role   = "${aws_iam_role.elb-presence.id}"
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Action": [
#         "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
#         "elasticloadbalancing:RegisterInstancesWithLoadBalancer"
#       ],
#       "Resource": [
#         "arn:aws:elasticloadbalancing:::*-dyn-elb",
#       ]
#     }
#   ]
# }
# EOF
# }
#
# resource "aws_iam_instance_profile" "elb-presence" {
#   name  = "${var.elb_presence_rolename}"
#   roles = [ "${aws_iam_role.elb-presence.id}" ]
# }

resource "aws_elb" "coreos_dynamic_router" {
  name = "${var.env}-tsuru-dyn-elb"
  subnets = ["${aws_subnet.public.*.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]

  health_check {
    target = "TCP:8080"
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
