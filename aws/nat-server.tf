resource "aws_instance" "nat" {
  ami = "${lookup(var.ubuntu_amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public.0.id}"
  security_groups = [
    "${aws_security_group.nat.id}",
    "${aws_security_group.nat_route.id}"
  ]
  key_name = "${var.key_pair_name}"
  source_dest_check = false
  tags = {
    Name = "${var.env}-tsuru-nat"
  }
  connection {
    user = "ubuntu"
    key_file = "ssh/insecure-deployer"
  }
  provisioner "remote-exec" {
    script = "../setup-nat-routing.sh"
  }
}

resource "aws_security_group" "nat" {
  name = "${var.env}-nat-tsuru"
  description = "Security group for nat instances that allows SSH from internet"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${split(",", var.office_cidrs)}","${var.jenkins_elastic}"]
  }

  tags {
    Name = "${var.env}-tsuru-nat"
  }
}

resource "aws_security_group" "nat_route" {
  name = "${var.env}-nat-route-tsuru"
  description = "Security group for nat instances that allows routing VPC traffic to internet"
  vpc_id = "${aws_vpc.default.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    security_groups = [
      "${aws_security_group.default.id}"
    ]
  }

  tags {
    Name = "${var.env}-tsuru-nat-route"
  }
}
