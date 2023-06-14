#!/bin/bash

# Run Terraform apply, -auto-approve makes it so that we don't have to type 'yes'
terraform apply -auto-approve

# Check if Terraform apply was successful
if [ $? -eq 0 ]; then

  # Get the public IP address of the instance
  instance_ip=$(terraform output -raw instance_ip_addr)

  # Get the key pair name from Terraform state
  echo "Retrieving key pair name from Terraform state..."
  key_pair_name=$(terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="aws_key_pair" and .name=="generated_key") | .values.key_name')
  echo "Key pair name: $key_pair_name"

  # Use the key pair name as the private key filename
  private_key_file="$key_pair_name"

  # Get the key pair from Terraform state
  echo "Retrieving key pair from Terraform state..."
  key_pair=$(terraform show -json | jq -r '.values.root_module.resources[] | select(.type=="aws_key_pair" and .name=="generated_key") | .values.key_pair_id')
  echo "Key pair ID: $key_pair"

  # Set appropriate permissions for the private key file
  chmod 400 $private_key_file

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
  
  echo "Commands executed successfully!"
else
  echo "Terraform apply failed."
fi