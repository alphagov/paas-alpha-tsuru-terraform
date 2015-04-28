/* Single instance postgres server */
resource "aws_instance" "postgres" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private1.id}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  tags = {
    Name = "tsuru-postgres"
  }
}
