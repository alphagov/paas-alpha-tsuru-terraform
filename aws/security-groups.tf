resource "aws_security_group" "default" {
  name = "${var.env}-default-tsuru"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  tags {
    Name = "${var.env}-tsuru-default"
  }
}

resource "aws_security_group" "nat" {
  name = "${var.env}-nat-tsuru"
  description = "Security group for nat instances that allows SSH and VPN traffic from internet"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}"]
  }

  tags {
    Name = "${var.env}-tsuru-nat"
  }
}

resource "aws_security_group" "gandalf" {
  name = "${var.env}-tsuru-gandalf"
  description = "Security group for Gandalf instance that allows SSH access from internet"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}","${aws_instance.nat.public_ip}/32"]
  }

  tags {
    Name = "${var.env}-tsuru-gandalf"
  }
}

resource "aws_security_group" "web" {
  name = "${var.env}-web-tsuru"
  description = "Security group for web that allows web traffic from internet"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}","${aws_instance.nat.public_ip}/32"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}","${aws_instance.nat.public_ip}/32"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}","${aws_instance.nat.public_ip}/32"]
  }

  tags {
    Name = "${var.env}-tsuru-web"
  }
}

/* FIXME: Unused, remove when deployed to CI */
resource "aws_security_group" "web-int" {
  name = "${var.env}-web-int-tsuru"
  description = "Security group for web that allows web traffic from internet"
  vpc_id = "${aws_vpc.default.id}"
}

/* FIXME: Unused, remove when deployed to CI */
resource "aws_security_group" "sslproxy" {
  name = "${var.env}-tsuru-sslproxy"
  description = "Security group for sslproxy/offloader feedind the tsuru router elb"
  vpc_id = "${aws_vpc.default.id}"
}
