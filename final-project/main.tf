terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-2"
  profile = "default"
}

# Security Groups
resource "aws_security_group" "minecraft-security" {
  name        = "minecraft-security"
  description = "Allow inbound traffic on port 25565 and SSH on port 22"

  ingress {
    from_port   = 25565
    to_port     = 25565
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

  tags = {
    Name = "minecraft security group"
  }
}

# Creates Key Pair
resource "aws_key_pair" "generated_key" {
  key_name   = "var.ssh_key_name"
  public_key = "var.public_key"
}

# Create Instance
resource "aws_instance" "minecraft" {
  ami                         = "ami-03f65b8614a860c29"
  instance_type               = "t3.medium"
  vpc_security_group_ids      = [aws_security_group.minecraft-security.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name
  tags = {
    Name = "Minecraft Server"
  }
}

# Outputs Public IP Address
output "instance_ip_addr" {
  value = aws_instance.minecraft.public_ip
}
