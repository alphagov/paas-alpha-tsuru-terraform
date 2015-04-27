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

