/* NAT/VPN server */
resource "aws_instance" "nat" {
  ami = "${lookup(var.nat_ami, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public1.id}"
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.nat.id}"]
  key_name = "${var.key_pair_name}"
  source_dest_check = false
  tags = { 
    Name = "${var.env}-tsuru-nat"
  }
  connection {
    user = "ec2-user"
    key_file = "ssh/insecure-deployer"
  }
  provisioner "remote-exec" {
    inline = [
      "yum update -y aws*",
      "echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward",
      "echo 0 | sudo tee /proc/sys/net/ipv4/conf/eth0/send_redirects",
      "sudo iptables -t nat -A POSTROUTING -o eth0 -s 0.0.0.0/0 -j MASQUERADE",
      "sudo iptables-save | sudo tee /etc/sysconfig/iptables",
      "sudo mkdir -p /etc/sysctl.d/",
      "echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/nat.conf",
      "echo 'net.ipv4.conf.eth0.send_redirects = 0' | sudo tee -a /etc/sysctl.d/nat.conf"
    ]
  }
}
