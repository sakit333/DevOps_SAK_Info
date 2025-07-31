#!/bin/bash

# ======================================================
# Ansible Worker Node Setup Script
# Script done by @sak_shetty
# ======================================================

echo "=== Step 1: System Update ==="
sudo apt update

echo "=== Step 2: Configure SSH ==="
sudo sed -i 's/^#\(PermitRootLogin\).*/\1 prohibit-password/' /etc/ssh/sshd_config
sudo sed -i 's/^#\(PubkeyAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#\(PasswordAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

echo "=== Step 3: Create ansible user ==="
if id "ansible" &>/dev/null; then
    echo "User 'ansible' already exists. Skipping creation."
else
    sudo useradd -m -s /bin/bash ansible
    echo "ansible:1234" | sudo chpasswd
fi

echo "=== Step 4: Grant Sudo Permission to ansible user ==="
if ! sudo grep -q "^ansible ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
    echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
else
    echo "Sudoers entry already exists for 'ansible'."
fi

echo "=== Step 5: Prepare .ssh directory ==="
sudo -u ansible mkdir -p /home/ansible/.ssh
sudo chmod 700 /home/ansible/.ssh
sudo touch /home/ansible/.ssh/authorized_keys
sudo chmod 600 /home/ansible/.ssh/authorized_keys
sudo chown -R ansible:ansible /home/ansible/.ssh

echo -e "\n=== MANUAL STEP REQUIRED ==="
echo "Paste the master's public SSH key into: /home/ansible/.ssh/authorized_keys"
echo "Run: sudo nano /home/ansible/.ssh/authorized_keys"
echo "Then: sudo systemctl restart ssh"
echo -e "\n============================\n"

echo "=== Script done by @sak_shetty ==="
