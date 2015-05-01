output "api.*.ip" {
  value = "${join(",", aws_instance.api.*.private_ip)}"
}

output "tsuru-db.ip" {
  value = "${aws_instance.tsuru-db.private_ip}"
}

output "docker.private.ip" {
  value = "${aws_instance.tsuru-docker.private_ip}"
}

output "docker-registry.private_ip" {
  value = "${aws_instance.docker-registry.private_ip}"
}

output "gandalf.private.ip" {
  value = "${aws_instance.gandalf.private_ip}"
}

output "gandalf.public.ip" {
  value = "${aws_instance.gandalf.public_ip}"
}

output "nat.ip" {
  value = "${aws_instance.nat.public_ip}"
}

output "postgres.private_ip" {
  value = "${aws_instance.postgres.private_ip}"
}

output "router.*.ip" {
  value = "${join(",", aws_instance.router.*.private_ip)}"
}

output "sslproxy.*.ip" {
  value = "${join(",", aws_instance.tsuru-sslproxy.*.private_ip)}"
}

output "elb.hostname" {
  value = "${aws_elb.router.dns_name}"
}
