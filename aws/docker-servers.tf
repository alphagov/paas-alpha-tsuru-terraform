/* Docker server */
resource "aws_instance" "tsuru-docker" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private.0.id}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-docker"
  }
}

