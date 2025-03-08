# Setting Up Ansible Master and Worker Nodes on Amazon Linux 2

## Step 1: Set Up the Master Node (Ansible Control Node)

### 1.1 Update and Install Ansible
On the **master EC2 instance**, install Ansible:

```sh
sudo yum update -y
sudo amazon-linux-extras enable ansible2
sudo yum install -y ansible
```

### 1.2 Enable Root SSH Access
Ensure root login via SSH is enabled:

```sh
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

### 1.3 Generate SSH Key for Root
Generate SSH keys for the **root user**:

```sh
sudo su -
ssh-keygen -t rsa -b 4096 -N "" -f /root/.ssh/id_rsa
```

---

## Step 2: Set Up the Worker Node

### 2.1 Enable Root SSH Access on Worker Node
On **each worker EC2 instance**, enable SSH for root:

```sh
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

### 2.2 Create SSH Directory for Root

```sh
sudo mkdir -p /root/.ssh
sudo chmod 700 /root/.ssh
```

---

## Step 3: Configure SSH Access from Master to Worker
On the **master node**, copy the **root SSH key** to each worker:

```sh
ssh-copy-id -i /root/.ssh/id_rsa.pub root@<worker-node-IP>
```

Example:

```sh
ssh-copy-id -i /root/.ssh/id_rsa.pub root@172.31.5.205
```

Test the SSH connection:

```sh
ssh root@172.31.5.205
```

If prompted, type **yes** and press **Enter**.

---

## Step 4: Configure Ansible Inventory
Edit the **Ansible hosts file** on the **master node**:

```sh
vi /etc/ansible/hosts
```

Add the worker node IP:

```ini
[dev]
172.31.5.205 ansible_user=root
```

Save and exit.

---

## Step 5: Test Ansible Connection
Run:

```sh
ansible dev -m ping
```

Expected output:

```json
172.31.5.205 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

---

### 🎉 You are now ready to execute Ansible commands as root!
Let me know if you need further help! 😊
