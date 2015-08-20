resource "aws_instance" "tsuru-db" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private.0.id}"
  security_groups = [
    "${aws_security_group.mongodb.id}",
    "${aws_security_group.redis.id}"
  ]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-db"
  }
}

resource "aws_security_group" "mongodb" {
  name = "${var.env}-mongodb"
  description = "MongoDB security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
      from_port = 0
      to_port = 27017
      protocol = "tcp"
      security_groups = [
        "${aws_security_group.tsuru_api.id}",
        "${aws_security_group.gandalf.id}"
      ]
  }

  tags = {
    Name = "${var.env}-tsuru-db"
  }
}

resource "aws_security_group" "redis" {
  name = "${var.env}-redis"
  description = "Redis security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
      from_port = 0
      to_port = 6379
      protocol = "tcp"
      security_groups = [
        "${aws_security_group.tsuru_api.id}",
        "${aws_security_group.router.id}"
      ]
  }

  tags = {
    Name = "${var.env}-tsuru-db"
  }
}
