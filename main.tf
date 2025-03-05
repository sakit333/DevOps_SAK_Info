 provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}
resource "aws_instance" "prod_ec2" {
  ami           = "ami-03b8adbf322415fd0"
  instance_type = "t2.micro"
  key_name      = "astroids_203"
  count         = 1
  tags = {
    Name = "prod_app_server-${count.index}"
  }
  security_groups = [aws_security_group.prod_sg.name]
  user_data       = file("ansible_userdata.sh")
}
resource "aws_security_group" "prod_sg" {
  tags = {
    Name = "production_sg"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
output "public_ip" {
  value = "EC2 Instance Public IP: ${aws_instance.prod_ec2[0].public_ip}"
}
output "private_ip" {
  value = "EC2 Instance Private IP: ${aws_instance.prod_ec2[0].private_ip}"
}