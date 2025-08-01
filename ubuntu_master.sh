#!/bin/bash

# ======================================================
# Ansible Master Node Setup Script
# Script by @sak_shetty - Finalized
# ======================================================

set -e

echo "=== Step 1: Updating system ==="
sudo apt update -y

echo "=== Step 2: Installing Ansible ==="
if ! command -v ansible &>/dev/null; then
    sudo apt install software-properties-common -y
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install ansible -y
else
    echo "Ansible is already installed. Skipping installation."
fi

echo "=== Ansible Version ==="
ansible --version || { echo "Ansible not found after installation. Exiting."; exit 1; }

# Step 3: Configure SSH
echo "=== Step 3: SSH Configuration ==="
sudo sed -i 's/^#\?\(PermitRootLogin\).*/\1 prohibit-password/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?\(PubkeyAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?\(PasswordAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Step 4: Create ansible user
echo "=== Step 4: Creating Ansible User ==="
if getent passwd ansible > /dev/null 2>&1; then
    echo "User 'ansible' already exists. Skipping creation."
else
    sudo useradd -m -s /bin/bash ansible
    echo "ansible:1234" | sudo chpasswd
    echo "User 'ansible' created with password '1234'."
fi

# Step 5: Grant sudo permission to ansible user
echo "=== Step 5: Granting Sudo Permissions ==="
if sudo grep -q "^ansible ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
    echo "Sudoers entry already exists for 'ansible'."
else
    echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
fi

# Step 6: Generate SSH Key
echo "=== Step 6: Generating SSH Key for ansible user ==="
SSH_DIR="/home/ansible/.ssh"
KEY_PATH="$SSH_DIR/id_rsa"

if [ ! -f "$KEY_PATH" ]; then
    sudo -u ansible mkdir -p "$SSH_DIR"
    sudo -u ansible chmod 700 "$SSH_DIR"
    sudo -u ansible ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""
else
    echo "SSH key already exists for ansible user. Skipping keygen."
fi


# Step 7: Interactive Ansible Inventory Setup
echo "=== Step 7: Ansible Inventory Setup ==="
sudo mkdir -p /etc/ansible
if [ ! -f /etc/ansible/hosts ]; then
    sudo touch /etc/ansible/hosts
fi

# Backup and clear hosts file
sudo cp /etc/ansible/hosts /etc/ansible/hosts.bak
echo "" | sudo tee /etc/ansible/hosts > /dev/null

read -p "Enter number of groups: " GROUP_COUNT

for (( i=1; i<=GROUP_COUNT; i++ )); do
    read -p "Enter name for group $i: " GROUP_NAME
    echo "[$GROUP_NAME]" | sudo tee -a /etc/ansible/hosts > /dev/null

    read -p "How many IPs in group '$GROUP_NAME': " IP_COUNT

    for (( j=1; j<=IP_COUNT; j++ )); do
        read -p "Enter IP $j for group '$GROUP_NAME': " IP
        echo "$IP" | sudo tee -a /etc/ansible/hosts > /dev/null
    done

    echo "" | sudo tee -a /etc/ansible/hosts > /dev/null
done

echo -e "\n=== Inventory saved to /etc/ansible/hosts ==="
cat /etc/ansible/hosts

# Step 8: Show public key
echo -e "\n=== COPY THIS KEY TO WORKER NODES ===\n"
sudo cat /home/ansible/.ssh/id_rsa.pub
echo -e "\n=====================================\n"

echo "=== Completed with Ansible Master node configuration ==="
echo -e "====================================="
echo "=== Script done by @sak_shetty ==="
