echo "Installing ansible"
sudo amazon-linux-extras install ansible2 -y
echo "provide hosts information manually"
echo "config /etc/ansible/ansible.cfg file"
sudo sed -i 's/^#\(inventory\s*=\s*\/etc\/ansible\/hosts\)/\1/' /etc/ansible/ansible.cfg
sudo sed -i 's/^#\(sudo_user\s*=\s*root\)/\1/' /etc/ansible/ansible.cfg
echo "/etc/ansible/ansible/cfg done"
sudo useradd ansible
echo "user is created"
echo "ansible:1234" | sudo chpasswd 
sudo sed -i '/^root\s\+ALL=(ALL)\s\+ALL/a ansible ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
service sshd restart
echo "Generating SSH key for ansible user"
sudo -u ansible ssh-keygen -t rsa -b 2048 -f /home/ansible/.ssh/id_rsa -q -N ""
echo "SSH key pair generated"
echo "master node configuration is done"
