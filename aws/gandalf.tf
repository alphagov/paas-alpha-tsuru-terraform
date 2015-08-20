resource "aws_instance" "gandalf" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.public.0.id}"
  associate_public_ip_address = true
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.gandalf.id}"
  ]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-gandalf"
  }
}

resource "aws_security_group" "gandalf" {
  name = "${var.env}-tsuru-gandalf"
  description = "Security group for Gandalf instance that allows SSH access from internet"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}","${aws_instance.nat.public_ip}/32"]
  }

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      security_groups = [
        "${aws_security_group.tsuru_api.id}",
      ]
  }

  ingress {
      from_port = 3232
      to_port = 3232
      protocol = "tcp"
      security_groups = [
        "${aws_security_group.tsuru_api.id}",
        "${aws_security_group.docker_node.id}"
      ]
  }

  tags {
    Name = "${var.env}-tsuru-gandalf"
  }
}
