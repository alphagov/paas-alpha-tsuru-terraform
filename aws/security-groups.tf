/* Default security group */
resource "aws_security_group" "default" {
  name = "default-tsuru-${var.env}"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${aws_vpc.default.id}"
  
  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }
  
  tags { 
    Name = "tsuru-default-${var.env}"
  }
}

/* Security group for the nat server */
resource "aws_security_group" "nat" {
  name = "nat-tsuru-${var.env}"
  description = "Security group for nat instances that allows SSH and VPN traffic from internet"
  vpc_id = "${aws_vpc.default.id}"
  
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}"]
  }
 
  tags { 
    Name = "tsuru-nat-${var.env}"
  }
}

/* Security group for the Gandalf server */
resource "aws_security_group" "gandalf" {
  name = "tsuru-gandalf-${var.env}"
  description = "Security group for Gandalf instance that allows SSH access from internet"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}"]
  }

  tags {
    Name = "tsuru-gandalf-${var.env}"
  }
}

/* Security group for the web */
resource "aws_security_group" "web" {
  name = "web-tsuru-${var.env}"
  description = "Security group for web that allows web traffic from internet"
  vpc_id = "${aws_vpc.default.id}"
  
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
    Name = "tsuru-web-${var.env}"
  }
}

/* Security group for the web */
resource "aws_security_group" "web-int" {
  name = "web-int-tsuru-${var.env}"
  description = "Security group for web that allows web traffic from internet"
  vpc_id = "${aws_vpc.default.id}"

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.sslproxy1.cidr_block}"]
  } 

   ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${aws_subnet.sslproxy2.cidr_block}"]
  } 

 /* bug of terraform 0.4.2 does not work with  security groups this way. Workarounds above.
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.sslproxy.id}"]
  } */

  tags { 
    Name = "tsuru-web-int-${var.env}"
  }
}

/* Security group for the sslproxy */
resource "aws_security_group" "sslproxy" {
  name = "tsuru-sslproxy-${var.env}"
  description = "Security group for sslproxy/offloader feedind the tsuru router elb"
  vpc_id = "${aws_vpc.default.id}"
  
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
    Name = "tsuru-sslproxy-${var.env}"
  }
}
