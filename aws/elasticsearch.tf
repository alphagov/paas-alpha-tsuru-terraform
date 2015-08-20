resource "aws_instance" "elasticsearch" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private.0.id}"
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.elasticsearch.id}"
  ]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-elasticsearch"
  }
}

resource "aws_security_group" "elasticsearch" {
  name = "${var.env}-elasticsearch"
  description = "Elasticsearch security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 0
    to_port   = 9200
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.docker_node.id}"
    ]
  }

  tags = {
    Name = "${var.env}-tsuru-elasticsearch"
  }
}
