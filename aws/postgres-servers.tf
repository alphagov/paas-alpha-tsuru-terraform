#
# These resources are commented out because not everyone has permissions
# necessary to create them.
#
#resource "aws_iam_role" "postgres" {
#  name = "${var.postgres_s3_rolename}"
#  assume_role_policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "",
#      "Effect": "Allow",
#      "Principal": { "Service": "ec2.amazonaws.com" },
#      "Action": "sts:AssumeRole"
#    }
#  ]
#}
#EOF
#}
#
#resource "aws_iam_role_policy" "postgres" {
#  name   = "${var.postgres_s3_rolename}"
#  role   = "${aws_iam_role.postgres.id}"
#  policy = <<EOF
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Sid": "",
#      "Effect": "Allow",
#      "Action": [ "s3:*" ],
#      "Resource": [
#        "arn:aws:s3:::*-${var.postgres_s3_bucketname}",
#        "arn:aws:s3:::*-${var.postgres_s3_bucketname}/*"
#      ]
#    }
#  ]
#}
#EOF
#}
#
#resource "aws_iam_instance_profile" "postgres" {
#  name  = "${var.postgres_s3_rolename}"
#  roles = [ "${aws_iam_role.postgres.id}" ]
#}

resource "aws_instance" "postgres" {
  count = 2
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  availability_zone = "${element(aws_subnet.private.*.availability_zone, count.index)}"
  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.postgres.id}"
  ]
  iam_instance_profile = "${var.postgres_s3_rolename}"
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-postgres-${count.index}"
  }
}

resource "aws_s3_bucket" "postgres-s3" {
    bucket = "${var.env}-${var.postgres_bucketname}"
    acl = "private"
    force_destroy = "${var.force_destroy}"
}

resource "aws_security_group" "postgres" {
  name = "${var.env}-postgres"
  description = "Postgres security group"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 0
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [
      "${aws_security_group.docker_node.id}"
    ]
  }

  tags = {
    Name = "${var.env}-tsuru-postgres-${count.index}"
  }
}
