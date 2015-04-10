/* Single instance postgres server */
resource "aws_instance" "postgres" {
  ami = "${lookup(var.nat_ami, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public.id}"
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.postgres.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  tags = {
    Name = "tsuru-postgres"
  }
  connection {
    user = "ec2-user"
    key_file = "ssh/insecure-deployer"
  }
}
