#!/bin/bash

# Run Terraform apply
terraform apply -auto-approve

# Check if Terraform apply was successful
if [ $? -eq 0 ]; then
  # Get the public IP address of the instance
  instance_ip=$(terraform output -raw instance_ip_addr)

  # SSH into the instance/ubuntu machine
  ssh -i /Users/blake/Downloads/mc-key2.pem ubuntu@$instance_ip '
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
  
  # Additional commands or actions after creating the folder
  # ...

  echo "Commands executed successfully!"
else
  echo "Terraform apply failed. Folder creation aborted."
fi

echo "Instance IP: $instance_ip"