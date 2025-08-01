#!/bin/bash

# ======================================================
# Ansible Worker Node Setup Script
# Script done by @sak_shetty
# Enhanced with Logging and Safe Sudo Ops
# ======================================================

LOG_FILE="/var/log/ansible_worker_setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

set -e

if ! [ -t 0 ]; then
  echo "⚠️  This script must be run in an interactive terminal."
  echo "ℹ️  Example: bash <(curl -sL https://raw.githubusercontent.com/sakit333/ansible_insta/ubuntu_sak/ubuntu_worker.sh)"
  exit 1
fi

echo "=== Logging to: $LOG_FILE ==="
echo "=== Step 1: System Update ==="
sudo apt update -y

echo "=== Step 2: Configure SSH ==="
sudo sed -i 's/^#\?\(PermitRootLogin\).*/\1 prohibit-password/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?\(PubkeyAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?\(PasswordAuthentication\).*/\1 yes/' /etc/ssh/sshd_config
sudo systemctl restart ssh

echo "=== Step 3: Create ansible user ==="
if id "ansible" &>/dev/null; then
    echo "User 'ansible' already exists. Skipping creation."
else
    sudo useradd -m -s /bin/bash ansible
    echo "ansible:1234" | sudo chpasswd
    echo "User 'ansible' created with password '1234'."
fi

echo "=== Step 4: Grant Sudo Permission to ansible user ==="
if ! sudo grep -q "^ansible ALL=(ALL) NOPASSWD: ALL" /etc/sudoers; then
    echo 'ansible ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo
else
    echo "Sudoers entry already exists for 'ansible'."
fi

echo "=== Step 5: Prepare .ssh directory for ansible user ==="
SSH_DIR="/home/ansible/.ssh"
sudo -u ansible mkdir -p "$SSH_DIR"
sudo chmod 700 "$SSH_DIR"
sudo touch "$SSH_DIR/authorized_keys"
sudo chmod 600 "$SSH_DIR/authorized_keys"
sudo chown -R ansible:ansible "$SSH_DIR"

echo -e "\n=== MANUAL STEP REQUIRED ==="
echo "📌 Paste the master's public SSH key into:"
echo "    /home/ansible/.ssh/authorized_keys"
echo -e "Run: \e[32msudo nano /home/ansible/.ssh/authorized_keys\e[0m"
echo "Then restart SSH with: sudo systemctl restart ssh"
echo -e "\n============================\n"

echo "✅ Worker node setup complete."
echo "=== Script done by @sak_shetty ==="
