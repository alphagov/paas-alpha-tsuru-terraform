/* Jumpbox Server Instance */
resource "google_compute_instance" "nat" {
  name = "tsuru-nat"
  machine_type = "n1-standard-1"
  zone = "${element(split(",", var.gce_zones), count.index)}"
  disk {
    image = "${var.os_image}"
  }
  network_interface {
    network = "${google_compute_network.network1.name}"
    access_config {
    }
  }
  metadata {
    sshKeys = "${var.user}:${file(\"${var.ssh_key_path}")}"
  }
  service_account {
    scopes = [ "compute-ro", "storage-ro", "userinfo-email" ]
  }
  depends_on = [ "google_compute_network.network1" ]

  can_ip_forward = true
  connection {
    user = "${var.user}"
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
  tags = [ "public", "nat" ]
}
