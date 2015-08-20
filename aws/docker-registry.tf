#
# These resources are commented because not all of us have access to create
# and modify things in IAM. This has been run once by dcarley and remains
# here for reference or future modification.
#
# resource "aws_iam_role" "docker-registry" {
#   name = "${var.registry_s3_rolename}"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Principal": { "Service": "ec2.amazonaws.com" },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }
#
# resource "aws_iam_role_policy" "docker-registry" {
#   name   = "${var.registry_s3_rolename}"
#   role   = "${aws_iam_role.docker-registry.id}"
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Sid": "",
#       "Effect": "Allow",
#       "Action": [ "s3:*" ],
#       "Resource": [
#         "arn:aws:s3:::*-${var.registry_s3_bucketname}",
#         "arn:aws:s3:::*-${var.registry_s3_bucketname}/*"
#       ]
#     }
#   ]
# }
# EOF
# }
#
# resource "aws_iam_instance_profile" "docker-registry" {
#   name  = "${var.registry_s3_rolename}"
#   roles = [ "${aws_iam_role.docker-registry.id}" ]
# }

resource "aws_instance" "docker-registry" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private.0.id}"
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.docker_registry.id}"
  ]
  key_name = "${var.key_pair_name}"
  iam_instance_profile = "${var.registry_s3_rolename}"
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
    force_destroy = "${var.force_destroy}"
}

resource "aws_security_group" "docker_registry" {
  name = "${var.env}-docker-registry"
  description = "Docker Node security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
      from_port = 0
      to_port = 6000
      protocol = "tcp"
      security_groups = [
        "${aws_security_group.docker_node.id}"
      ]
  }

  tags = {
    Name = "${var.env}-tsuru-registry"
  }
}
