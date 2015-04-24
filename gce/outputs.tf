output "app.0.ip" {
  value = "${google_compute_instance.tsuru-app.0.network_interface.0.address}"
}

output "app.1.ip" {
  value = "${google_compute_instance.tsuru-app.1.network_interface.0.address}"
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

output "elb.hostname" {
  value = "${google_compute_forwarding_rule.router.ip_address}"
}
