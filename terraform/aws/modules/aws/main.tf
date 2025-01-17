terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# Externe Security Group 

resource "aws_security_group" "security" {
  count       = var.enabled ? 1 : 0
  name        = var.module
  #vpc_id      = aws_vpc.vpc[0].id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access vom Subnetz
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# VMs

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "vm" {
  count                         = var.enabled ? 1 : 0
  # ami                           = var.image
  ami                           = data.aws_ami.ubuntu.id  
  instance_type                 = "t2.micro"
  associate_public_ip_address   = true
  user_data                     = data.template_file.lernmaas.rendered
  vpc_security_group_ids        = [aws_security_group.security[0].id]

  tags = {
    Name = var.module
  }
  
  root_block_device {
    volume_size = 32
  }
}

