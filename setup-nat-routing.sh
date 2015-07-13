#!/bin/bash

set -e

echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
echo 0 | sudo tee /proc/sys/net/ipv4/conf/eth0/send_redirects
sudo mkdir -p /etc/sysctl.d/
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/nat.conf
echo 'net.ipv4.conf.eth0.send_redirects = 0' | sudo tee -a /etc/sysctl.d/nat.conf

sudo iptables -t nat -A POSTROUTING -o eth0 -s 0.0.0.0/0 -j MASQUERADE

# Cloudinit changes the package repositories, which can make fail next steps.
# Let's wait for it to finish.
while pgrep cloud-init > /dev/null; do echo "Waiting for cloudinit to finish..."; sleep 1; done

sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y iptables-persistent
sudo service iptables-persistent save

