#                                      #
## This does not work. Providers cannot have a `count`
## provider "docker" {
##   count = "§\\
#
##
## Each host with a docker node needs an adhoc provider :(
##
#provider "docker" {
#  host = "tcp://${aws_instance.coreos-admin.0.private_ip}:4243/"
#  alias = "admin_0"
#}
#provider "docker" {
#  host = "tcp://${aws_instance.coreos-admin.1.private_ip}:4243/"
#  alias = "admin_1"
#}
#provider "docker" {
#  host = "tcp://${aws_instance.coreos-admin.2.private_ip}:4243/"
#  alias = "admin_2"
#}
#
##
## This does not work. It does not do interpolation in the provider variable
##
## resource "docker_image" "ubuntu_count" {
##  count = 3
##  name = "ubuntu:raring"
##  provider = "docker.admin_${count.index}"
## }
##
#
#
#resource "docker_image" "ubuntu" {
#  name = "ubuntu:raring"
#  provider = "docker.admin_0"
#}
#resource "docker_container" "foo" {
#  image = "${docker_image.ubuntu.latest}"
#  name = "foo"
#  command = [ "/bin/sleep", "6000" ]
#  provider = "docker.admin_0"
#}
#
