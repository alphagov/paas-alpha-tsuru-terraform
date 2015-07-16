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
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private.0.id}"
  security_groups = ["${aws_security_group.default.id}"]
  iam_instance_profile = "${var.postgres_s3_rolename}"
  key_name = "${var.key_pair_name}"
  tags = {
    Name = "${var.env}-tsuru-postgres-${count.index}"
  }
}

resource "aws_s3_bucket" "postgres-s3" {
    bucket = "${var.env}-${var.postgres_s3_bucketname}"
    acl = "private"
    force_destroy = "${var.force_destroy}"
}

