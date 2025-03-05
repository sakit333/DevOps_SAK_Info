#!/bin/bash

yum update -y
useradd ansible
echo "ansible:1234" | chpasswd 
echo "ansible ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd
echo "General Node configuration is done"
