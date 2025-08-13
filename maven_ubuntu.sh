#!/bin/bash
#=============================================================
#  Java 17 & Apache Maven 3.9.11 Installation Script for Ubuntu 24.04
#  Created by: @sak_shetty
#  Role: DevOps Engineer & Corporate Trainer
#  Purpose: Install Java 17 (headless) & Maven system-wide if not already installed
#=============================================================

set -e  # Exit on error

echo "=============================================="
echo "☕ Java 17 + ⚙️ Apache Maven 3.9.11 Setup Script"
echo "👨‍💻 Maintained by: DevOps Engineer & Corp Trainer @sak_shetty"
echo "🎯 Purpose: Install Java 17 & Maven system-wide on Ubuntu 24.04"
echo "=============================================="

# Update server packages
echo "🔹 Updating system packages..."
sudo apt update -y && sudo apt upgrade -y
sudo apt autoremove -y

# Install Java 17 if not installed
if java -version 2>/dev/null | grep -q "17"; then
    echo "✅ Java 17 is already installed. Skipping installation."
else
    echo "☕ Installing Java 17 (headless)..."
    sudo apt install -y openjdk-17-jdk-headless
    java -version
fi

# Install wget if not present
if ! command -v wget &>/dev/null; then
    echo "📦 Installing wget..."
    sudo apt install -y wget
fi

# Install Maven if not installed
if mvn -v 2>/dev/null | grep -q "Apache Maven 3.9.11"; then
    echo "✅ Apache Maven 3.9.11 is already installed. Skipping installation."
else
    echo "📦 Downloading Apache Maven 3.9.11..."
    wget https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz -P /tmp

    echo "📂 Extracting Maven..."
    sudo tar -zxvf /tmp/apache-maven-3.9.11-bin.tar.gz -C /opt
    sudo rm -f /tmp/apache-maven-3.9.11-bin.tar.gz

    echo "📦 Setting Maven directory..."
    sudo rm -rf /opt/maven
    sudo mv /opt/apache-maven-3.9.11 /opt/maven

    echo "⚙️ Configuring Maven in system-wide PATH..."
    sudo tee /etc/profile.d/maven.sh > /dev/null <<EOF
export M2_HOME=/opt/maven
export PATH=\$M2_HOME/bin:\$PATH
EOF

    sudo chmod +x /etc/profile.d/maven.sh
    source /etc/profile.d/maven.sh

    echo "✅ Apache Maven 3.9.11 installed successfully."
fi

# Final check
echo "=============================================="
echo "✅ Installation Summary:"
java -version
mvn -v
echo "=============================================="
