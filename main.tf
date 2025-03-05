resource "aws_instance" "prod_ec2_jen" {
  ami           = "ami-03b8adbf322415fd0"
  instance_type = "t2.micro"
  key_name      = "Manu_sak_admin"
  count         = 1
  tags = {
    Name = "prod_jen_server-${count.index}"
  }
  security_groups = [aws_security_group.prod_jen_sg.name]
  user_data       = file("jen_user.sh")
}
resource "aws_security_group" "prod_jen_sg" {
  tags = {
    Name = "prod_jen_sg"
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
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
  value = "EC2 Instance Public IP: ${aws_instance.prod_ec2_jen[0].public_ip}"
}
output "private_ip" {
  value = "EC2 Instance Private IP: ${aws_instance.prod_ec2_jen[0].private_ip}"
}