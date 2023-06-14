# How to Setup a Minecraft Server with Terraform and Bash Script

**Welcome! This tutorial will demonstrate how to create a Minecraft server with AWS EC2. The twist is that we will utilize Infrastructure as Code (IaC), eliminating the need to interact with the AWS Management page. We will achieve this with the assistance of Terraform and Bash Script.**

## Prerequisites 

* Access to AWS CLI to retrieve credentials and paste into ./aws/credentials

* Have Terraform configured with ./aws/credentials

* Install fq package, this retrieves the keypair you created in Terraform and puts it into the script, allowing us to ssh into the ubuntu machine.
  * ```brew install jq``` for MacOS users
  * ``` sudo yum install epel-release ``` and ``` sudo yum install jq ``` For CentOS or Red Hat-based systems
  * ```sudo apt update``` and ```sudo apt install jq``` For Ubuntu or Debian-based systems

## Configuring main.tf

### 1) Setup version and region you want the instance created on
```
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
}
```

### 2) Setup/Configure security groups
```
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
```

### 3) Create key pair 

```
# Creates Key Pair
resource "aws_key_pair" "generated_key" {
  key_name   = "var.ssh_key_name" <--- #You can name this whatever you want
  public_key = "var.public_key"   <--- #Create a public key or use an existing, paste the public key in here
```

### 4) Setup/Configure Instance, this creates the instance on AWS

```
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
```

### 5) Output Public IP Address, this is the IP used to connect to the minecraft server

```
output "instance_ip_addr" {
  value = aws_instance.minecraft.public_ip
}
```
<hr>

## Making script.sh file (Note: this file should run completely fine without you needing to change anything)

### 1) Script starts with running ```terraform apply -auto-approve```

```
#!/bin/bash

# Run Terraform apply
terraform apply -auto-approve
```

### 2) Once terraform apply is successful, this part retrieves the keypair that was made in the main.tf and set appropriate permissions for the key

```
# Check if Terraform apply was successful
if [ $? -eq 0 ]; then

  # Get the public IP address of the instance
  instance_ip=$(terraform output -raw instance_ip_addr)

  # Get the key pair name from Terraform state
  echo "Retrieving key pair name from Terraform state..."
  key_pair_name=$(terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="aws_key_pair" and .name=="deployer") | .values.key_name')
  echo "Key pair name: $key_pair_name"

  # Use the key pair name as the private key filename
  private_key_file="$key_pair_name"

  # Get the key pair from Terraform state
  echo "Retrieving key pair from Terraform state..."
  key_pair=$(terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="aws_key_pair" and .name=="deployer") | .values.key_pair_id')
  echo "Key pair ID: $key_pair"

  # Set appropriate permissions for the private key file
  chmod 400 $private_key_file
```

### 3) After retrieving the key pair, the script can now SSH into the Ubuntu machine, enabling us to execute commands for installing Java and configuring the server.jar files for the Minecraft server

```
 # SSH into the instance/ubuntu machine
  ssh -i $private_key_file.pem ubuntu@$instance_ip '
  sudo apt update 
  sudo apt upgrade  
  sudo add-apt-repository ppa:linuxuprising/java 
  echo oracle-java17-installer shared/accepted-oracle-license-v1-3 select true | sudo /usr/bin/debconf-set-selections
  sudo apt install oracle-java17-installer 
  mkdir /home/ubuntu/minecraft 
  cd minecraft 
  wget https://piston-data.mojang.com/v1/objects/84194a2f286ef7c14ed7ce0090dba59902951553/server.jar 
  java -Xmx1024M -Xms1024M -jar server.jar nogui 
  sed -i "s/eula=false/eula=true/" eula.txt 
  java -Xmx1024M -Xms1024M -jar server.jar nogui
  '
```
<hr>

## How to Run Everything!
Please run it in the following commands:

1) ```terraform init```
2) ```terraform apply```
3) ```./script.sh```

The Minecraft should be up and running now, if you lost the Public IP Address, open a new terminal and ```terraform apply``` where main.tf is located at and it should print out the IP.


## References
1. https://github.com/HarryNash/terraform-minecraft
2. https://dev.to/aws/build-on-aws-weekly-s1-e2-breaking-blocks-with-terraform-4dlb
3. https://stackoverflow.com/questions/19275856/auto-yes-to-the-license-agreement-on-sudo-apt-get-y-install-oracle-java7-instal
4. https://stackoverflow.com/questions/57158310/how-to-restart-ec2-instance-using-terraform-without-destroying-them
5. https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-build
