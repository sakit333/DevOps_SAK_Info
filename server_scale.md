## Terraform AWS EC2 Instance Setup

### Provider Configuration
```hcl
provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}
variable "instance_count" {
  default = 1 
}
resource "aws_instance" "prod_ec2" {
  count         = var.instance_count
  ami           = "ami-03b8adbf322415fd0"
  instance_type = "t2.micro"
  key_name      = "astroids_203"

  tags = {
    Name = "prod_app_server-${count.index}"
  }

  vpc_security_group_ids = [aws_security_group.prod_sg.id]
  user_data             = file("ansible_userdata.sh")
}

resource "aws_security_group" "prod_sg" {
  tags = {
    Name = "production_sg"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "public_ips" {
  value = [for instance in aws_instance.prod_ec2 : "Public IP: ${instance.public_ip}"]
}

output "private_ips" {
  value = [for instance in aws_instance.prod_ec2 : "Private IP: ${instance.private_ip}"]
}
```

### How to Scale Up Without Removing Existing Servers
1. **Deploy with 1 server first:**
   ```sh
   terraform apply -var="instance_count=1"
   ```
2. **Later, scale up to 3 servers:**
   ```sh
   terraform apply -var="instance_count=3"
   ```
   - Terraform will **only add the extra servers**, keeping the existing ones intact.

---