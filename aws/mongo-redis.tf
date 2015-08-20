resource "aws_instance" "tsuru-db" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private.0.id}"
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.redis.id}"
  ]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-db"
  }
}


resource "aws_security_group" "redis" {
  name = "redis"
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
}
