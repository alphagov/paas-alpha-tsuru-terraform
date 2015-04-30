/* Docker Registry */
resource "aws_instance" "docker-registry" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private1.id}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "docker-registry-${var.env}"
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 100
  }
}

resource "aws_s3_bucket" "registry-s3" {
    bucket = "${var.registry_s3_bucketname}-${var.env}"
    acl = "private"
}

