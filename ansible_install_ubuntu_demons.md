# Ansible_Installation_For_DevOps (ansible core 2.18.6)
---
## System requirments 
- ami: Ubuntu 24.04
- Instance Type: t2.micro
- Security Group: All traffic
- Term: MobaxTerm
- 2 server
  - master node
  - worker node

# Follow the steps for installation
---
### Step-1: update the ubuntu machine all the nodes(root)
```bash
sudo apt update
```

### Step-2: install ansible (master node > root)
```bash
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
ansible --version
```

### Step-3: add worker nodes to hosts(master node > root)
```bash
vi /etc/ansible/hosts
```
- example
```bash
[dev]
172.31.3.178
```

### Step-4: configure ssh(all the nodes > root)
```bash
vi /etc/ssh/sshd_config
```
- uncomment the below statements
```bash
PermitRootLogin prohibit-password
PubkeyAuthentication yes
PasswordAuthentication yes
```

### Step-5: restart ssh compulsory (all the nodes > root)
```bash
sudo systemctl restart ssh
```

### Step-6: create ansible user with password(all the nodes > root)
```bash
sudo useradd -m -s /bin/bash ansible
passwd ansible
```
- password: 1234

### Step-7: Provide ansible user permission(all the nodes > root)
```bash
visudo
```
- Add these line for permission
```bash
ansible ALL=(ALL) NOPASSWD: ALL
```

### Step-8: to check from ansible user (master node > ansible)
```bash
sudo apt install apache2 -y
sudo systemctl status apache2
```

### Step-9: generate ssh keygen (master node > ansible)
```bash
sudo -u ansible ssh-keygen -t rsa -b 4096 -f /home/ansible/.ssh/id_rsa -N ""
```
- enter

### Step-10: check with rsa keys
```bash
cat /home/ansible/.ssh/id_rsa.pub
```

#### example rsa keys from master node
```bash
ansible@ip-172-31-15-141:~/.ssh$ cat id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDnFbF9aJcg50gslsA5BoBUZrzCZnMpJXCVFNCE7vEL7dLZxq/UpY0IOQZXa4SJXBCzVVoRCyvVFHEQkisZn+kIjjbMHLXAOFDyx6sLhyWOwk0tLUbtZTmTgpOK91jLiHlOYJ59jlr4rl+CBZSX9W0CFhOyOz0mz3+b91IyJBp1SvEBqE818K3ACmcU4QqxQ1ETuW0X/m4m56tOED+rhXUWsVlZBW3hMD7P7lOpeCK8aQpw5AGrQ3z2VzOjhOOinSatY8I2tT1R0MvhzfHwl1NOL2rW8woqxquKyD3aCDioTd0SekO6jGlSOGNbh7e0I4ifOqPV3EGikzukrHVTRvxbpabzxiLojJIXzXv/Tn+kULB5gaRocdv+rkQBtCDvGJbiUmF2e+CvRHKOiHa4vcCKCAomzsoJdVnmcjsJKmja7cpahekrevpwZyz+yQbG8eCZsqpdqJfYHyFxcISvbZhKEuBNYJppRYcSS3Ev3RFTWzDierco8MSvFJEbBcGFteslTRzlp19UGy64X+cPCJOaicLAs4gWwhWza3HQVfOPnvvO+RHe5OzWcBVCzE561S75GgE6TVXh0muOVdfyOYtdEBhKKsZ1IwHBousHLVTA+epGPCO5dV7YhJag2NUBE2bGBhcqfchkrlUxBnzktdZStjQRpVRcjTYhzMrC/eoB2w== ansible@ip-172-31-15-141
```
### Step-11: create directory and file(worker nodes > ansible)
```bash
sudo -u ansible mkdir -p /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
touch /home/ansible/.ssh/authorized_keys
chmod 600 /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh
```

### Step-12: copy id_rsa.pub from master node to worker nodes (ansible)
- copy ssh-rsa from master node(ansible)
```bash
cat /home/ansible/.ssh/id_rsa.pub
```
- paste it in worker nodes in this file authorized_keys(ansible)
```bash
cat > /home/ansible/.ssh/authorized_keys
```

### Step-13: restart ssh in worker node(root)
```bash
sudo systemctl restart ssh
```

### Step-14: manually access worker nodes(master node > ansible)
```bash
ssh ansible@172.31.3.178
```
- it will ask permission type(yes)
- exit

### Step-15: final step check with ansible command (master node > ansible)
```bash
ansible dev -m ping
```
- *OUTPUT* it will show success
```bash
172.31.3.178 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "ping": "pong"
}
```
---
*completed with the ansible script done by SAK*

 







