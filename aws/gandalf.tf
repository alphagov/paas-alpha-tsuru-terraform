/* Gandalf server */
resource "aws_instance" "gandalf" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.public1.id}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.gandalf.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "tsuru-app-gandalf"
  }
}

