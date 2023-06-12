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
  region = "us-west-2"
}

variable "mojang_server_url" {
  type    = string
  default = "https://launcher.mojang.com/v1/objects/e00c4052dac1d59a1188b2aa9d5a87113aaf1122/server.jar"
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
  ami           = "ami-03f65b8614a860c29"
  instance_type = "t3.medium"
  vpc_security_group_ids = ["sg-09495713dec44541c"]
  subnet_id              = "subnet-0be6db793e48c3326"
  associate_public_ip_address = true
  key_name = "mc-key2"
  user_data = <<-EOF
    #!/bin/bash
    sudo yum -y update
    sudo rpm --import https://yum.corretto.aws/corretto.key
    sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
    sudo yum install -y java-17-amazon-corretto-devel.x86_64
    wget -O server.jar ${var.mojang_server_url}
    java -Xmx1024M -Xms1024M -jar server.jar nogui
    sed -i 's/eula=false/eula=true/' eula.txt
    screen -d -m java -Xmx1024M -Xms1024M -jar server.jar nogui
    EOF  
  tags = {
    Name = "Minecraft Server"
  }
}

output "instance_ip_addr" {
  value = aws_instance.minecraft.public_ip
}
