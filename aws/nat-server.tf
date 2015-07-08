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
    inline = [
      "echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward",
      "echo 0 | sudo tee /proc/sys/net/ipv4/conf/eth0/send_redirects",
      "sudo apt-get update -qq",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq iptables-persistent",
      "sudo iptables -t nat -A POSTROUTING -o eth0 -s 0.0.0.0/0 -j MASQUERADE",
      "sudo service iptables-persistent save",
      "sudo mkdir -p /etc/sysctl.d/",
      "echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/nat.conf",
      "echo 'net.ipv4.conf.eth0.send_redirects = 0' | sudo tee -a /etc/sysctl.d/nat.conf"
    ]
  }
}
