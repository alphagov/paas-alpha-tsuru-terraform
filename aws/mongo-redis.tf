resource "aws_ebs_volume" "tsuru-db" {
    availability_zone = "${element(aws_subnet.private.*.availability_zone, 0)}"
    size = 40
    tags {
        Name = "tsuru-db"
    }
}

resource "aws_instance" "tsuru-db" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private.0.id}"
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.mongodb.id}",
    "${aws_security_group.redis.id}"
  ]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-db"
  }
  user_data = "${file("user-data.tsuru-db")}"
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/xvdh"
  volume_id = "${aws_ebs_volume.tsuru-db.id}"
  instance_id = "${aws_instance.tsuru-db.id}"
}

resource "aws_security_group" "mongodb" {
  name = "${var.env}-mongodb"
  description = "MongoDB security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
      from_port = 27017
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
      from_port = 6379
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
