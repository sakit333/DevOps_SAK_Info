useradd ansible
passwd ansible
sudo sed -i '/^root\s\+ALL=(ALL)\s\+ALL/a ansible ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
service sshd restart
