output "app.0.private_ip" {
  value = "${google_compute_instance.tsuru-app.0.network_interface.0.address}"
}

output "docker.private_ip" {
  value = "${google_compute_instance.tsuru-docker.network_interface.0.address}"
}

output "docker-registry.private_ip" {
  value = "${google_compute_instance.docker-registry.network_interface.0.address}"
}

output "gandalf.private.ip" {
  value = "${google_compute_instance.gandalf.network_interface.0.address}"
}

output "gandalf.public.ip" {
  value = "${google_compute_instance.gandalf.network_interface.0.access_config.0.nat_ip}"
}

output "nat.ip" {
  value = "${google_compute_instance.nat.network_interface.0.access_config.0.nat_ip}"
}

output "postgres.private_ip" {
  value = "${google_compute_instance.postgres.network_interface.0.address}"
}

output "sslproxy.*.private_ip" {
  value = "${join(",", google_compute_instance.tsuru-sslproxy.*.network_interface.0.address)}"
}

output "router.*.private_ip" {
  value = "${join(",", google_compute_instance.router.*.network_interface.0.address)}"
}

output "elb.hostname" {
  value = "${google_compute_forwarding_rule.router.ip_address}"
}
