#!/bin/bash

cat <<EOF >> /etc/hosts
192.168.0.134 haproxy1.example.com haproxy1
192.168.0.135 haproxy2.example.com haproxy2
192.168.0.136 dns.example.com dns
192.168.0.137 storage.example.com storage
192.168.0.138 db.example.com db
192.168.0.120 controller1.example.com controller1
192.168.0.121 controller2.example.com controller2
192.168.0.122 controller3.example.com controller3
192.168.0.125 compute1.example.com compute1
192.168.0.126 compute2.example.com compute2
192.168.0.127 compute3.example.com compute3
EOF

ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa.pub root@dns
ssh-copy-id -i ~/.ssh/id_rsa.pub root@storage
ssh-copy-id -i ~/.ssh/id_rsa.pub root@db
ssh-copy-id -i ~/.ssh/id_rsa.pub root@controller1
ssh-copy-id -i ~/.ssh/id_rsa.pub root@controller2
ssh-copy-id -i ~/.ssh/id_rsa.pub root@controller3
ssh-copy-id -i ~/.ssh/id_rsa.pub root@compute1
ssh-copy-id -i ~/.ssh/id_rsa.pub root@compute2
ssh-copy-id -i ~/.ssh/id_rsa.pub root@compute3

dnf update -y
yum -y install epel-release
yum -y install ansible

systemctl disable --now firewalld
setenforce 0
sed -i 's/enforcing/permissive/g' /etc/selinux/config
