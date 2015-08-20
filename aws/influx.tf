resource "aws_instance" "influx-grafana" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.public.0.id}"
  associate_public_ip_address = true
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.grafana.id}"
  ]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-influx-grafana"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }
}

resource "aws_security_group" "grafana" {
  name = "${var.env}-grafana-tsuru"
  description = "Security group for grafana that allows traffic from the office"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}","${aws_instance.nat.public_ip}/32"]
  }

  ingress {
    from_port = 8083
    to_port   = 8083
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}","${aws_instance.nat.public_ip}/32"]
  }

  tags {
    Name = "${var.env}-influx-grafana"
  }
}
