/* Default security group */
resource "aws_security_group" "default" {
  name = "default-tsuru"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  tags {
    Name = "tsuru-default-vpc"
  }
}


/* Security group for the nat server */
resource "aws_security_group" "nat" {
  name = "nat-tsuru"
  description = "Security group for nat instances that allows SSH and VPN traffic from internet"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["80.194.77.0/24"]
  }

  tags {
    Name = "tsuru-nat"
  }
}

/* Security group for the Gandalf server */
resource "aws_security_group" "gandalf" {
  name = "tsuru-gandalf"
  description = "Security group for Gandalf instance that allows SSH access from internet"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["80.194.77.0/24"]
  }

  tags {
    Name = "tsuru-gandalf"
  }
}

/* Security group for the web */
resource "aws_security_group" "web" {
  name = "web-tsuru"
  description = "Security group for web that allows web traffic from internet"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["80.194.77.0/24"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["80.194.77.0/24"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["80.194.77.0/24"]
  }

  tags {
    Name = "tsuru-web"
  }
}

/* Security group for the postgres */
resource "aws_security_group" "postgres" {
  name = "postgres-tsuru"
  description = "Security group for postgres server"
  vpc_id = "${aws_vpc.default.id}"


  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = ["80.194.77.0/24"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["80.194.77.0/24"]
  }

  tags {
    Name = "tsuru-postgres"
  }
}

