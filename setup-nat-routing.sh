#!/bin/bash

set -e

echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
echo 0 | sudo tee /proc/sys/net/ipv4/conf/eth0/send_redirects
sudo apt-get update -qq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq iptables-persistent
sudo iptables -t nat -A POSTROUTING -o eth0 -s 0.0.0.0/0 -j MASQUERADE
sudo service iptables-persistent save
sudo mkdir -p /etc/sysctl.d/
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/nat.conf
echo 'net.ipv4.conf.eth0.send_redirects = 0' | sudo tee -a /etc/sysctl.d/nat.conf

