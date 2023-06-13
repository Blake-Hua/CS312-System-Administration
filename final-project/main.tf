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

/*resource "aws_security_group" "minecraft" {
  ingress {
    description = "Minecraft port"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Send Anywhere"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Minecraft Security Group"
  }
}*/

# Network settings
resource "aws_instance" "minecraft" {
  ami                         = "ami-03f65b8614a860c29"
  instance_type               = "t3.medium"
  vpc_security_group_ids      = ["sg-09495713dec44541c"]
  subnet_id                   = "subnet-0be6db793e48c3326"
  associate_public_ip_address = true
  key_name                    = "mc-key2"
  tags = {
    Name = "Minecraft Server"
  }
}


output "instance_ip_addr" {
  value = aws_instance.minecraft.public_ip
}
