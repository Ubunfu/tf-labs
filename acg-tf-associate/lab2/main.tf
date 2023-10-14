terraform {
  required_providers {
    aws = {
      version = "5.21.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create an AWS key pair to connect to the server
# Create the keypair locally first by running ssh-keygen!
resource "aws_key_pair" "kp_web" {
  key_name   = "kp_web"
  public_key = file("~/.ssh/kp-web.pub")
}

# Create a security group for the web server
resource "aws_security_group" "sg_web" {
  name = "sg_web"
  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow ssh"
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

# Provision the server
resource "aws_instance" "myvm" {
  ami                         = "ami-0bb4c991fa89d4b9b" # AMZ linux 2 x86
  subnet_id                   = "subnet-9f7267d6"       # us-east-1a
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.kp_web.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.sg_web.id]
  tags = {
    Name = "my-first-tf-vm"
  }
  provisioner "local-exec" {
    command = "echo \"Launched VM with public IP: ${self.public_ip}!\" > ip.txt"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1>Hello from Terraform!</h1>' > index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = self.public_ip
      private_key = file("~/.ssh/kp-web")
    }
  }
}
