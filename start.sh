#!/bin/bash
ssh-keygen
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.20
ssh-copy-id -i ~/.ssh/id_rsa.pub root@192.168.0.30

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

cat <<EOF > /root/ansible/setting/inventory
[controlservers]
192.168.0.20

[computeservers]
192.168.0.30

[allservers:children]
controlservers
computeservers
EOF

dnf install -y tar
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
mkdir ~/bin
sh get_helm.sh
mv /usr/local/bin/helm ~/bin

