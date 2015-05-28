resource "aws_instance" "docker-registry" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private.0.id}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-registry"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }
}

resource "aws_s3_bucket" "registry-s3" {
    bucket = "${var.env}-${var.registry_s3_bucketname}"
    acl = "private"
}

