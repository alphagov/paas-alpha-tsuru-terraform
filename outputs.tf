output "app.0.ip" {
  value = "${aws_instance.tsuru-app.0.private_ip}"
}

output "app.1.ip" {
  value = "${aws_instance.tsuru-app.1.private_ip}"
}

output "app.2.ip" {
  value = "${aws_instance.tsuru-app.2.private_ip}"
}

output "nat.ip" {
  value = "${aws_instance.nat.public_ip}"
}

output "elb.hostname" {
  value = "${aws_elb.router.dns_name}"
}
