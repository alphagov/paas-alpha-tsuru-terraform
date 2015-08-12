resource "aws_instance" "influx-grafana" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.public.0.id}"
  associate_public_ip_address = true
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.grafana.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-influx-grafana"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }
}

