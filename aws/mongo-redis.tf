/* MongoDB and Redis DB server */
resource "aws_instance" "tsuru-db" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private1.id}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "tsuru-db-${var.env}"
  }
}

