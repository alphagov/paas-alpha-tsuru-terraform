/* Docker Registry */
resource "aws_instance" "docker-registry" {
  count = 1
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.medium"
  subnet_id = "${aws_subnet.private1.id}"
  security_groups = ["${aws_security_group.default.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  user_data = "${file(\"cloud-config/docker-registry.yml\")}"
  tags = {
    Name = "docker-registry-${count.index}"
  }
}
