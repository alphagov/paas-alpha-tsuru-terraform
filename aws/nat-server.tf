resource "aws_instance" "nat" {
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public.0.id}"
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.nat.id}"]
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
