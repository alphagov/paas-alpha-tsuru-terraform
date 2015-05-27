/* Default security group */
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

/* Security group for the nat server */
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

/* Security group for the Gandalf server */
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
    cidr_blocks = ["${split(",", var.office_cidrs)}"]
  }

  tags {
    Name = "${var.env}-tsuru-gandalf"
  }
}

/* Security group for the web */
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
    cidr_blocks = ["${split(",", var.office_cidrs)}"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}"]
  }

  tags {
    Name = "${var.env}-tsuru-web"
  }
}

/* Security group for the web */
resource "aws_security_group" "web-int" {
  name = "${var.env}-web-int-tsuru"
  description = "Security group for web that allows web traffic from internet"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.sslproxy.*.cidr_block}"]
  }

 /* bug of terraform 0.4.2 does not work with  security groups this way. Workarounds above.
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.sslproxy.id}"]
  } */

  tags {
    Name = "${var.env}-tsuru-web-int"
  }
}

/* Security group for the sslproxy */
resource "aws_security_group" "sslproxy" {
  name = "${var.env}-tsuru-sslproxy"
  description = "Security group for sslproxy/offloader feedind the tsuru router elb"
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
    cidr_blocks = ["${split(",", var.office_cidrs)}"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}"]
  }

  tags {
    Name = "${var.env}-tsuru-sslproxy"
  }
}
