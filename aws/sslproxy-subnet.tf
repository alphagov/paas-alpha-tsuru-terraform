resource "aws_subnet" "sslproxy" {
  count             = 2
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${lookup(var.sslproxy_cidrs, concat("zone", count.index))}"
  availability_zone = "${lookup(var.zones, concat("zone", count.index))}"
  map_public_ip_on_launch = false
  depends_on = ["aws_instance.nat"]
  tags { 
    Name = "${var.env}-tsuru-sslproxy-${count.index}"
  }
}

resource "aws_route_table" "sslproxy" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
}

resource "aws_route_table_association" "sslproxy" {
  count =2 
  subnet_id = "${element(aws_subnet.sslproxy.*.id, count.index)}"
  route_table_id = "${aws_route_table.sslproxy.id}"
}
