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

# AMI for x64 amazon linux 2 OS image
# Will be used for the EC2 server
data "aws_ssm_parameter" "ami_amz_linux2_x64" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Public TF module to create a new AWS VPC
module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  name           = "my-tf-vpc"
  cidr           = "10.0.0.0/16"
  azs            = ["us-east-1a"]
  public_subnets = ["10.0.1.0/24"]
}

# Create a new security group for the EC2 web server
resource "aws_security_group" "sg-web" {
  vpc_id = module.vpc.vpc_id
  name   = join("_", ["sg", module.vpc.vpc_id])
  #   Build the ingress rules dynamically using the "web_ingress_rules variable"
  dynamic "ingress" {
    for_each = var.web_ingress_rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr"]
    }
  }
  #   Egress rules are to allow anything going out anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tf-web-sg"
  }
}

# Start a web server
resource "aws_instance" "web-server" {
  ami                         = data.aws_ssm_parameter.ami_amz_linux2_x64.value
  subnet_id                   = module.vpc.public_subnets[0]
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.sg-web.id]
  #   If a bootstrap script exists, use it, otherwise don't bootstrap the server
  user_data = fileexists("script.sh") ? file("script.sh") : null
}
