/* Private subnet1 */
resource "aws_subnet" "private1" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.private_subnet1_cidr}"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = false
  depends_on = ["aws_instance.nat"]
  tags { 
    Name = "${var.env}-tsuru-private1"
  }
}

/* Private subnet2 */
resource "aws_subnet" "private2" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.private_subnet2_cidr}"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = false
  depends_on = ["aws_instance.nat"]
  tags {
    Name = "${var.env}-tsuru-private2"
  }
}

/* Routing table for private subnets */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
}

/* Associate the routing table to private subnets */
resource "aws_route_table_association" "private1" {
  subnet_id = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.private.id}"
}

/* Associate the routing table to private subnets */
resource "aws_route_table_association" "private2" {
  subnet_id = "${aws_subnet.private2.id}"
  route_table_id = "${aws_route_table.private.id}"
}
