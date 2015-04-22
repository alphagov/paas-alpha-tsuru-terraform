/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

/* Public subnet 1 */
resource "aws_subnet" "public1" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet1_cidr}"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.default"]
  tags {
    Name = "tsuru-public-subnet-1"
  }
}

/* Public subnet 2 */
resource "aws_subnet" "public2" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet2_cidr}"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = true
  depends_on = ["aws_internet_gateway.default"]
  tags {
    Name = "tsuru-public-subnet-2"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "public1" {
  subnet_id = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.public.id}"
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "public2" {
  subnet_id = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.public.id}"
}
