/* Private subnet1 */
resource "aws_subnet" "sslproxy1" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.sslproxy_subnet1_cidr}"
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = false
  depends_on = ["aws_instance.nat"]
  tags { 
    Name = "${var.env}-tsuru-sslproxy1"
  }
}

/* Private subnet2 */
resource "aws_subnet" "sslproxy2" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.sslproxy_subnet2_cidr}"
  availability_zone = "${var.region}b"
  map_public_ip_on_launch = false
  depends_on = ["aws_instance.nat"]
  tags {
    Name = "${var.env}-tsuru-sslproxy2"
  }
}

/* Routing table for private subnets */
resource "aws_route_table" "sslproxy" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
}

/* Associate the routing table to private subnets */
resource "aws_route_table_association" "sslproxy1" {
  subnet_id = "${aws_subnet.sslproxy1.id}"
  route_table_id = "${aws_route_table.sslproxy.id}"
}

/* Associate the routing table to private subnets */
resource "aws_route_table_association" "sslproxy2" {
  subnet_id = "${aws_subnet.sslproxy2.id}"
  route_table_id = "${aws_route_table.sslproxy.id}"
}


