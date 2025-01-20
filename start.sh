#!/bin/bash
ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.110
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.120
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.121
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.122
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.200

cat <<EOF >> /etc/hosts
192.168.0.110 controller1.example.com controller1
192.168.0.120 compute1.example.com compute1
192.168.0.121 compute2.example.com compute2
192.168.0.122 compute3.example.com compute3
192.168.0.200 storage1.example.com storage1
EOF

dnf update -y
yum -y install epel-release
yum -y install ansible

systemctl disable --now firewalld
setenforce 0
sed -i 's/enforcing/permissive/g' /etc/selinux/config

mkdir /root/.kube
export KUBECONFIG=/root/.kube/admin.conf
export KUBERNETES_VERSION=v1.30

cat <<EOF | tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/rpm/repodata/repomd.xml.key
EOF
dnf -y install kubectl

mkdir /root/ansible
mkdir /root/ansible/setting

dnf install -y tar
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
mkdir ~/bin
sh get_helm.sh
mv /usr/local/bin/helm ~/bin

